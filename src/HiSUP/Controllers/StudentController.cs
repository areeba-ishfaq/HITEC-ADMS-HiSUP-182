using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using HiSUP.Data;
using HiSUP.Models;

namespace HiSUP.Controllers
{
    public class StudentController : Controller
    {
        private readonly HiSUPContext _context;

        public StudentController(HiSUPContext context)
        {
            _context = context;
        }

        // GET: Student/Dashboard/5
        public async Task<IActionResult> Dashboard(int id)
        {
            var student = await _context.Students
                .FirstOrDefaultAsync(s => s.StudentID == id);

            if (student == null)
            {
                return NotFound();
            }

            return View(student);
        }

        // GET: Student/Register
        public async Task<IActionResult> Register()
        {
            var courses = await _context.Courses.ToListAsync();
            return View(courses);
        }

        // POST: Student/Register
        [HttpPost]
        public async Task<IActionResult> Register(int studentId, int courseId)
        {
            try
            {
                // First find a section for this course
                var section = await _context.Sections
                    .FirstOrDefaultAsync(s => s.CourseID == courseId);

                if (section == null)
                {
                    TempData["Error"] = "No section available for this course";
                    return RedirectToAction("Register");
                }

                // Call stored procedure using ADO.NET
                using (var connection = new SqlConnection(_context.Database.GetConnectionString()))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("EnrollInCourse", connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@StudentID", studentId);
                        command.Parameters.AddWithValue("@SectionID", section.SectionID);

                        var enrollmentIdParam = new SqlParameter("@EnrollmentID", System.Data.SqlDbType.Int);
                        enrollmentIdParam.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(enrollmentIdParam);

                        await command.ExecuteNonQueryAsync();
                    }
                }

                TempData["Success"] = "Successfully enrolled in course!";
            }
            catch (SqlException ex)
            {
                // Handle the duplicate enrollment error
                if (ex.Message.Contains("already enrolled"))
                {
                    TempData["Error"] = "You are already enrolled in this course!";
                }
                else
                {
                    TempData["Error"] = "Enrollment failed: " + ex.Message;
                }
            }

            return RedirectToAction("Dashboard", new { id = studentId });
        }
    }
}