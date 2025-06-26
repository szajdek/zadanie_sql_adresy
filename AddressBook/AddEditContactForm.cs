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
    public partial class AddEditContactForm : Form
    {
        private int contactId;
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public AddEditContactForm()
        {
            InitializeComponent();
            Text = "Dodawanie kontaktu";
        }

        public AddEditContactForm(int contactId)
        {
            InitializeComponent();
            Text = "Edycja kontaktu";
            this.contactId = contactId;
        }

        private void AddEditContactForm_Load(object sender, EventArgs e)
        {
            statusComboBox.SelectedIndex = 0;
            FillCityComboBox();
            if (contactId != 0)
            {
                FillForm(contactId);
            }
        }        

        private void saveButton_Click(object sender, EventArgs e)
        {
            if (ValidateForm())
            {
                if (contactId == 0)
                {
                    AddContact();
                }
                else
                {
                    UpdateContact(contactId);
                }
            }
        }

        private void addCityButton_Click(object sender, EventArgs e)
        {
            AddCityForm addCityForm = new AddCityForm();
            addCityForm.ShowDialog();
            if (addCityForm.DialogResult == DialogResult.OK)
            {
                FillCityComboBox();
            }
        }

        private void FillCityComboBox()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("GetAllCities", connection);
                    dataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    cityComboBox.DataSource = dataTable;
                    cityComboBox.DisplayMember = "PostalCodeAndCity";
                    cityComboBox.ValueMember = "Id";
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }            
        }

        private void FillForm(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("GetContactById", connection);
                    dataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                    dataAdapter.SelectCommand.Parameters.AddWithValue("@Id", id);
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    firstNameTextBox.Text = dataTable.Rows[0][1].ToString();
                    lastNameTextBox.Text = dataTable.Rows[0][2].ToString();
                    dateOfBirthDateTimePicker.Text = dataTable.Rows[0][3].ToString();
                    phoneNumberTextBox.Text = dataTable.Rows[0][4].ToString();
                    statusComboBox.SelectedItem = dataTable.Rows[0][5].ToString();
                    cityComboBox.SelectedValue = dataTable.Rows[0][6].ToString();
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }            
        }

        private bool ValidateForm()
        {
            if (firstNameTextBox.Text.Trim() != "" && lastNameTextBox.Text.Trim() != "" && phoneNumberTextBox.Text.Trim() != "")
            {
                return true;
            }
            else
                MessageBox.Show("Uzupełnij wszystkie pola");
            return false;
        }

        private void AddContact()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("AddContact", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@FirstName", firstNameTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@LastName", lastNameTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@DateOfBirth", dateOfBirthDateTimePicker.Value);
                    command.Parameters.AddWithValue("@PhoneNumber", phoneNumberTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@Status", statusComboBox.Text);
                    command.Parameters.AddWithValue("@CityId", cityComboBox.SelectedValue);
                    command.ExecuteNonQuery();
                    MessageBox.Show("Dodano kontakt");
                    DialogResult = DialogResult.OK;
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }            
        }

        private void UpdateContact(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("UpdateContact", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Id", id);
                    command.Parameters.AddWithValue("@FirstName", firstNameTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@LastName", lastNameTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@DateOfBirth", dateOfBirthDateTimePicker.Value);
                    command.Parameters.AddWithValue("@PhoneNumber", phoneNumberTextBox.Text.Trim());
                    command.Parameters.AddWithValue("@Status", statusComboBox.Text);
                    command.Parameters.AddWithValue("@CityId", cityComboBox.SelectedValue);
                    command.ExecuteNonQuery();
                    MessageBox.Show("Zaktualizowano kontakt");
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
