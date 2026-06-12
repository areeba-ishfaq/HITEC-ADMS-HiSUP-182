using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class Section
    {
        [Key]
        public int SectionID { get; set; }

        public int CourseID { get; set; }

        public int FacultyID { get; set; }

        public string SectionCode { get; set; }

        public string Semester { get; set; }

        public int Year { get; set; }

        public int Capacity { get; set; }

        public int EnrolledCount { get; set; }
    }
}