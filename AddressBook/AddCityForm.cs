using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AddressBook
{
    public partial class AddCityForm : Form
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public AddCityForm()
        {
            InitializeComponent();
        }

        private void saveButton_Click(object sender, EventArgs e)
        {
            if (ValidateForm())
            {
                AddCity();
            }
        }

        private bool ValidateForm()
        {
            if (postalCodeTextBox.Text.Trim() != "" && cityTextBox.Text.Trim() != "")
            {
                return true;
            }
            else
                MessageBox.Show("Uzupełnij wszystkie pola");
            return false;
        }

        private void AddCity()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("AddCity", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PostalCode", postalCodeTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@City", cityTextBox.Text.Trim());
                    command.ExecuteNonQuery();
                    MessageBox.Show("Dodano miejscowość");
                    DialogResult = DialogResult.OK;
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }            
        }
    }
}
