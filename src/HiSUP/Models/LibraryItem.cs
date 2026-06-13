using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class LibraryItem
    {
        [Key]
        public int BookID { get; set; }

        public string Title { get; set; }

        public string Author { get; set; }

        public string ISBN { get; set; }

        public string Category { get; set; }

        public bool IsAvailable { get; set; }

        public int AvailableCopies { get; set; }
    }
}