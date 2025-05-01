using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations; //Necesario para el uso de [Key]
using System.ComponentModel.DataAnnotations.Schema; //Necesario para el uso de [DatabaseGenerated]

namespace EvaluacionContinua2.Models
{
    public class Pet
    {
            [Key]
            [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
            public int Id { get; set; }
            public string Nombre { get; set; }
            public int Edad { get; set; }
            public string Tipo { get; set; }
            public string EstadoAdopcion { get; set; } // "Adoptado" o "No adoptado"

            public Adoption? Adoption { get; set; }
    }
}