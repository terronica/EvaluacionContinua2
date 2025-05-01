using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using EvaluacionContinua2.Models;

namespace EvaluacionContinua2.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Pet> Pets { get; set; }
        public DbSet<Adopter> Adopters { get; set; }
        public DbSet<Adoption> Adoptions { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Pet>()
                .HasOne(p => p.Adoption)
                .WithOne(a => a.Pets)
                .HasForeignKey<Adoption>(a => a.PetId)
                .IsRequired();

            modelBuilder.Entity<Adoption>()
                .HasOne(a => a.Adopter)
                .WithMany(d => d.Adopciones);
        }
    }
}