namespace Backend.Models;

public class Order
{
    public int Id { get; set; }

    public int CustomerId { get; set; }

    public User Customer { get; set; } = null!;

    public decimal TotalAmount { get; set; }

    public string Status { get; set; } = "Pending";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public List<OrderItem> OrderItems { get; set; } = new();
}