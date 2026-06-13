using HiSUP.Data;
using HiSUP.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace HiSUP.Controllers
{
    public class FacultyController : Controller
    {
        private readonly HiSUPContext _context;

        public FacultyController(HiSUPContext context)
        {
            _context = context;
        }

        // GET: Faculty/Dashboard/500
        public async Task<IActionResult> Dashboard(int id)
        {
            var faculty = await _context.Faculty.FindAsync(id);
            if (faculty == null)
            {
                return NotFound();
            }
            return View(faculty);
        }

        // GET: Faculty/MarkAttendance
        public async Task<IActionResult> MarkAttendance(int facultyId, int sectionId)
        {
            ViewBag.FacultyId = facultyId;
            ViewBag.SectionId = sectionId;

            // Get students enrolled in this section
            var students = await (from e in _context.Enrollments
                                  join s in _context.Students on e.StudentID equals s.StudentID
                                  where e.SectionID == sectionId
                                  select s).ToListAsync();

            return View(students);
        }

        // POST: Faculty/MarkAttendance
        [HttpPost]
        public async Task<IActionResult> MarkAttendance(int studentId, int sectionId, string status, DateTime date)
        {
            try
            {
                using (var connection = new SqlConnection(_context.Database.GetConnectionString()))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("MarkAttendance", connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@StudentID", studentId);
                        command.Parameters.AddWithValue("@SectionID", sectionId);
                        command.Parameters.AddWithValue("@AttendanceDate", date);
                        command.Parameters.AddWithValue("@Status", status);

                        await command.ExecuteNonQueryAsync();
                    }
                }
                TempData["Success"] = "Attendance marked successfully!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("MarkAttendance", new { facultyId = 500, sectionId = sectionId });
        }
    
    // GET: Faculty/EnterGrades
public async Task<IActionResult> EnterGrades(int facultyId, int sectionId)
        {
            ViewBag.FacultyId = facultyId;
            ViewBag.SectionId = sectionId;

            // Get students enrolled in this section
            var students = await (from e in _context.Enrollments
                                  join s in _context.Students on e.StudentID equals s.StudentID
                                  where e.SectionID == sectionId
                                  select new { s.StudentID, s.Name, e.EnrollmentID }).ToListAsync();

            return View(students);
        }

        // POST: Faculty/EnterGrades
        [HttpPost]
        public async Task<IActionResult> EnterGrades(int enrollmentId, decimal grade, int sectionId)
        {
            try
            {
                using (var connection = new SqlConnection(_context.Database.GetConnectionString()))
                {
                    await connection.OpenAsync();
                    using (var command = new SqlCommand("AddExamResult", connection))
                    {
                        command.CommandType = System.Data.CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                        command.Parameters.AddWithValue("@MarksObtained", grade);
                        command.Parameters.AddWithValue("@TotalMarks", 100);

                        var gradeIdParam = new SqlParameter("@GradeID", System.Data.SqlDbType.Int);
                        gradeIdParam.Direction = System.Data.ParameterDirection.Output;
                        command.Parameters.Add(gradeIdParam);

                        await command.ExecuteNonQueryAsync();
                    }
                }
                TempData["Success"] = "Grade entered successfully!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Error: " + ex.Message;
            }

            return RedirectToAction("EnterGrades", new { facultyId = 500, sectionId = sectionId });
        }
    }
}
