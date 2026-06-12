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

        [Phone]
        public string Phone { get; set; }

        public string Gender { get; set; }

        public DateTime EnrollmentDate { get; set; }

        public string Status { get; set; }

        public decimal? CGPA { get; set; }

        public int DepartmentID { get; set; }
        public int ProgramID { get; set; }
    }
}