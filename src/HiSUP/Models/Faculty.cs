using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Faculty
    {
        [Key]
        public int FacultyID { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public string Designation { get; set; }

        public int DepartmentID { get; set; }

        public DateTime HireDate { get; set; }
    }
}