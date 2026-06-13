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

        // GET: Student/FeePayment
        public async Task<IActionResult> FeePayment(int id)
        {
            ViewBag.StudentId = id;

            // Get outstanding fee using your function
            using (var connection = new SqlConnection(_context.Database.GetConnectionString()))
            {
                await connection.OpenAsync();
                using (var command = new SqlCommand("SELECT dbo.fn_GetOutstandingFee(@StudentID)", connection))
                {
                    command.Parameters.AddWithValue("@StudentID", id);
                    var outstanding = await command.ExecuteScalarAsync();
                    ViewBag.OutstandingFee = outstanding ?? 0;
                }
            }

            return View();
        }

        // POST: Student/FeePayment
        [HttpPost]
        public async Task<IActionResult> FeePayment(int studentId, decimal amount, string paymentMethod)
        {
            try
            {
                using (var connection = new SqlConnection(_context.Database.GetConnectionString()))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("ProcessFeePayment", connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@StudentID", studentId);
                        command.Parameters.AddWithValue("@AmountPaid", amount);
                        command.Parameters.AddWithValue("@PaymentMethod", paymentMethod);

                        var paymentIdParam = new SqlParameter("@PaymentID", System.Data.SqlDbType.Int);
                        paymentIdParam.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(paymentIdParam);

                        await command.ExecuteNonQueryAsync();
                    }
                }

                TempData["Success"] = "Payment processed successfully!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Payment failed: " + ex.Message;
            }

            return RedirectToAction("Dashboard", new { id = studentId });
        }

        // GET: Student/Transcript
        public async Task<IActionResult> Transcript(int id)
        {
            ViewBag.StudentId = id;

            // Get student info
            var student = await _context.Students.FindAsync(id);
            ViewBag.StudentName = student?.Name;

            // Get grades
            var grades = await (from e in _context.Enrollments
                                join sec in _context.Sections on e.SectionID equals sec.SectionID
                                join c in _context.Courses on sec.CourseID equals c.CourseID
                                where e.StudentID == id
                                select new
                                {
                                    c.CourseCode,
                                    c.CourseName,
                                    c.CreditHours,
                                    GradeValue = 0.0m  // Default value
                                }).ToListAsync();

            return View(grades);
        }

    }
}