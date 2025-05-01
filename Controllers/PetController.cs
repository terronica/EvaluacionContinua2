using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using EvaluacionContinua2.Models;
using EvaluacionContinua2.Data;
using Microsoft.EntityFrameworkCore;

namespace EvaluacionContinua2.Controllers
{
    public class PetController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PetController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Crear()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Pet pet)
        {
            if (ModelState.IsValid)
            {
                _context.Add(pet);
                await _context.SaveChangesAsync();
                return RedirectToAction("","");
            }
            return View(pet);
        }

        public async Task<IActionResult> Asignar()
        {
            var mascotasDisponibles = await _context.Pets
                .Where(p => p.EstadoAdopcion == "disponible")
                .ToListAsync();

            ViewBag.Mascotas = mascotasDisponibles;

            return View();
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Adoptar(int PetId, string NombreAdoptante)
        {
            var pet = await _context.Pets.FindAsync(PetId);
            if (pet == null || pet.EstadoAdopcion == "adoptada")
                return BadRequest("Mascota no disponible");

            var adoptante = new Adopter { Nombre = NombreAdoptante };
            _context.Adopters.Add(adoptante);
            await _context.SaveChangesAsync();

            var adopcion = new Adoption
            {
                PetId = PetId,
                AdopterId = adoptante.Id
            };

            pet.EstadoAdopcion = "adoptada";
            _context.Adoptions.Add(adopcion);
            await _context.SaveChangesAsync();

            return RedirectToAction("","");
        }

        public async Task<IActionResult> ListaAdopciones()
        {
            var adopciones = await _context.Adoptions
                .Include(a => a.Pets)
                .Include(a => a.Adopter)
                .ToListAsync();

            return View(adopciones);
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View("Error!");
        }
    }
}