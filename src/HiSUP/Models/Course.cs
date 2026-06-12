using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Course
    {
        [Key]
        public int CourseID { get; set; }

        [Required]
        public string CourseCode { get; set; }

        [Required]
        public string CourseName { get; set; }

        public int CreditHours { get; set; }

        public int DepartmentID { get; set; }
    }
}