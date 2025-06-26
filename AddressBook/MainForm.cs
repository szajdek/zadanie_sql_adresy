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
    public partial class MainForm : Form
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private DataTable contactsDataTable;

        public MainForm()
        {
            InitializeComponent();
        }

        private void formContacts_Load(object sender, EventArgs e)
        {
            FillContactsDataGridView();
        }

        private void addContactButton_Click(object sender, EventArgs e)
        {
            AddEditContactForm addContactForm = new AddEditContactForm();
            addContactForm.ShowDialog();
            if (addContactForm.DialogResult == DialogResult.OK)
            {
                FillContactsDataGridView();
            }
        }

        private void editContactButton_Click(object sender, EventArgs e)
        {
            if (contactsDataGridView.CurrentRow.Index != -1)
            {
                int selectedContactId = Convert.ToInt32(contactsDataGridView.CurrentRow.Cells[0].Value.ToString());
                AddEditContactForm editContactForm = new AddEditContactForm(selectedContactId);
                editContactForm.ShowDialog();
                if (editContactForm.DialogResult == DialogResult.OK)
                {
                    FillContactsDataGridView();
                }
            }
        }

        private void searchTextBox_TextChanged(object sender, EventArgs e)
        {
            DataView contactsDataView = contactsDataTable.DefaultView;
            string filter = "FirstName like '%" + searchTextBox.Text + "%'" +
                "OR LastName like '%" + searchTextBox.Text + "%'" +
                "OR PhoneNumber like '%" + searchTextBox.Text + "%'" +
                "OR Status like '%" + searchTextBox.Text + "%'" +
                "OR PostalCode like '%" + searchTextBox.Text + "%'" +
                "OR City like '%" + searchTextBox.Text + "%'";
            contactsDataView.RowFilter = filter;
        }

        private void FillContactsDataGridView()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("GetAllContacts", connection);
                    dataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;
                    contactsDataTable = new DataTable();
                    dataAdapter.Fill(contactsDataTable);
                    contactsDataGridView.DataSource = contactsDataTable;
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message, "Błąd", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }            
        }        
    }
}
