using Microsoft.EntityFrameworkCore;

namespace HiSUP.Data;

public class HiSUPContext : DbContext
{
    public HiSUPContext(DbContextOptions<HiSUPContext> options)
        : base(options)
    {
    }
    
    public DbSet<Department> Departments { get; set; }
}

public class Department
{
    public int DepartmentID { get; set; }
    public string DeptName { get; set; }
    public string DeptCode { get; set; }
    public int? EstablishedYear { get; set; }
    public DateTime? CreatedAt { get; set; }
}