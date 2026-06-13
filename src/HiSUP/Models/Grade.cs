using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Grade
    {
        [Key]
        public int GradeID { get; set; }

        public int EnrollmentID { get; set; }

        public decimal GradeValue { get; set; }

        public string GradeLetter { get; set; }

        public string Remarks { get; set; }
    }
}