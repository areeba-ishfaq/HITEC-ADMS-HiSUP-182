using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Student
    {
        [Key]
        public int StudentID { get; set; }

        [Required]
        public string CNIC { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public string? Phone { get; set; }  // ← Allow null

        public string? Gender { get; set; }  // ← Allow null

        public DateTime EnrollmentDate { get; set; }

        public string? Status { get; set; }  // ← Allow null

        public decimal? CGPA { get; set; }

        public int DepartmentID { get; set; }
        public int ProgramID { get; set; }
    }
}