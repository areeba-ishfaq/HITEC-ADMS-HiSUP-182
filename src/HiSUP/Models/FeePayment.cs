using System.ComponentModel.DataAnnotations;

namespace HiSUP.Models
{
    public class FeePayment
    {
        [Key]
        public int PaymentID { get; set; }

        public int StudentID { get; set; }

        public decimal AmountPaid { get; set; }

        public DateTime PaymentDate { get; set; }

        public string PaymentMethod { get; set; }

        public string TransactionID { get; set; }
    }
}