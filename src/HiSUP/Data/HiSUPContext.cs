using HiSUP.Models;
using Microsoft.EntityFrameworkCore;
using static System.Collections.Specialized.BitVector32;

namespace HiSUP.Data
{
    public class HiSUPContext : DbContext
    {
        public HiSUPContext(DbContextOptions<HiSUPContext> options)
            : base(options)
        {
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Course> Courses { get; set; }
        public DbSet<Enrollment> Enrollments { get; set; }
        public DbSet<Models.Section> Sections { get; set; }
        public DbSet<FeePayment> FeePayments { get; set; }
        public DbSet<Grade> Grades { get; set; }
        public DbSet<Faculty> Faculty { get; set; }
        public DbSet<LibraryItem> LibraryItems { get; set; }
    }
}