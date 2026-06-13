using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HiSUP.Data;
using HiSUP.Models;

namespace HiSUP.Controllers
{
    public class LibraryController : Controller
    {
        private readonly HiSUPContext _context;

        public LibraryController(HiSUPContext context)
        {
            _context = context;
        }

        // GET: Library/Search
        public async Task<IActionResult> Search(string searchTerm)
        {
            ViewBag.SearchTerm = searchTerm;

            var books = from b in _context.LibraryItems
                        select b;

            if (!string.IsNullOrEmpty(searchTerm))
            {
                books = books.Where(b => b.Title.Contains(searchTerm) ||
                                         b.Author.Contains(searchTerm));
            }

            return View(await books.ToListAsync());
        }
    }
}