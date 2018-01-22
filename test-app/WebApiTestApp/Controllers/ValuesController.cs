using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.ResponseCaching.Internal;
using Microsoft.Extensions.Configuration;

namespace WebApiTestApp.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : Controller
    {
        private readonly IConfiguration _configuration;

        public ValuesController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IEnumerable<string> Get()
        {
            var connectionString = _configuration["Data:ConnectionString"];
            var api1IpAddress = _configuration["Data:Api1IpAddress"]; 
            var api2IpAddress = _configuration["Data:Api2IpAddress"];

            var responses = new List<string>();

            if (!string.IsNullOrWhiteSpace(connectionString) && !string.Equals(connectionString, "NA", StringComparison.InvariantCultureIgnoreCase))
            {
                responses.Add($"response from db: {CallDatabase(connectionString)}");
            }

            if (!string.IsNullOrWhiteSpace(api1IpAddress) && !string.Equals(api1IpAddress, "NA", StringComparison.InvariantCultureIgnoreCase))
            {
                responses.Add($"response from api1 ({api1IpAddress}): {CallWebApi(api1IpAddress)}");
            }

            if (!string.IsNullOrWhiteSpace(api2IpAddress) && !string.Equals(api2IpAddress, "NA", StringComparison.InvariantCultureIgnoreCase))
            {
                responses.Add($"response from api2 ({api2IpAddress}): {CallWebApi(api2IpAddress)}");
            }

            return responses.ToArray();
        }

        private static string CallDatabase(string connectionString)
        {
            string result;
            try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (var command = new SqlCommand("SELECT DB_NAME() AS [Current Database];", connection))
                    {
                        result = command.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }

            return result;
        }

        private static string CallWebApi(string ipAddress)
        {
            string result;
            try
            {
                using (var client = new System.Net.Http.HttpClient())
                {
                    client.BaseAddress = new Uri($"http://{ipAddress}");
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/json"));
                    var response = client.GetAsync("api/values").Result;
                    result = response.Content.ReadAsStringAsync().Result;
                }
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }

            return result;
        }
    }
}
