using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Enrollment
    {
        [Key]
        public int EnrollmentID { get; set; }

        public int StudentID { get; set; }

        public int SectionID { get; set; }

        public DateTime EnrollmentDate { get; set; }

        public string Status { get; set; }
    }
}