using HiSUP.Data;
using HiSUP.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace HiSUP.Controllers
{
    public class AdminController : Controller
    {
        private readonly HiSUPContext _context;

        public AdminController(HiSUPContext context)
        {
            _context = context;
        }

        // GET: Admin/Dashboard
        public async Task<IActionResult> Dashboard()
        {
            ViewBag.TotalStudents = await _context.Students.CountAsync();
            ViewBag.TotalFaculty = await _context.Faculty.CountAsync();
            ViewBag.TotalCourses = await _context.Courses.CountAsync();
            ViewBag.TotalEnrollments = await _context.Enrollments.CountAsync();

            return View();
        }

        // GET: Admin/Students
        public async Task<IActionResult> Students()
        {
            var students = await _context.Students.ToListAsync();
            return View(students);
        }

        // GET: Admin/EditStudent/5
        public async Task<IActionResult> EditStudent(int id)
        {
            var student = await _context.Students.FindAsync(id);
            if (student == null)
            {
                return NotFound();
            }
            return View(student);
        }

        // POST: Admin/EditStudent
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditStudent(int id, Student student)
        {
            if (id != student.StudentID)
            {
                return NotFound();
            }

            try
            {
                // Use raw SQL to update (bypasses trigger issue)
                int rowsAffected = await _context.Database.ExecuteSqlRawAsync(
                    @"UPDATE Students 
              SET Name = {0}, Email = {1}, Phone = {2}, Status = {3} 
              WHERE StudentID = {4}",
                    student.Name, student.Email, student.Phone, student.Status, student.StudentID);

                if (rowsAffected > 0)
                {
                    TempData["Success"] = "Student updated successfully!";
                }
                else
                {
                    TempData["Error"] = "Student not found!";
                }
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Update failed: " + ex.Message;
            }

            return RedirectToAction(nameof(Students));
        }

        // GET: Admin/DeleteStudent/5
        public async Task<IActionResult> DeleteStudent(int id)
        {
            try
            {
                int rowsAffected = await _context.Database.ExecuteSqlRawAsync(
                    "DELETE FROM Students WHERE StudentID = {0}", id);

                if (rowsAffected > 0)
                {
                    TempData["Success"] = "Student deleted successfully!";
                }
                else
                {
                    TempData["Error"] = "Student not found!";
                }
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("REFERENCE constraint"))
                {
                    TempData["Error"] = "Cannot delete student because they are enrolled in courses. Please remove enrollments first.";
                }
                else
                {
                    TempData["Error"] = "Delete failed: " + ex.Message;
                }
            }

            return RedirectToAction(nameof(Students));
        }
    }
}