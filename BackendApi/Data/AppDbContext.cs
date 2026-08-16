using Microsoft.EntityFrameworkCore;
using Backend.Models;

namespace Backend.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
        
    }
    public DbSet<User>Users{get;set;}
    public DbSet<Product>Products{get;set;}

    public DbSet<Order>Orders{get;set;}
    public DbSet<OrderItem> OrderItems{get;set;}

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Order>()
        .HasOne(o=>o.Customer)
        .WithMany()
        .HasForeignKey(o=>o.CustomerId)
        .OnDelete(DeleteBehavior.Restrict);  

        modelBuilder.Entity<OrderItem>()
        .HasOne(oi=>oi.Order)
        .WithMany(o=>o.OrderItems)
        .HasForeignKey(oi=>oi.OrderId);


        modelBuilder.Entity<OrderItem>()
        .HasOne(oi=>oi.Product)
        .WithMany()
        .HasForeignKey(oi=>oi.ProductId)
        .OnDelete(DeleteBehavior.Restrict);
    }
}