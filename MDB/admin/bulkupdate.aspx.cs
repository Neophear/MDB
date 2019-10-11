using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB.admin
{
    public partial class bulkupdate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();

            lblOutput.Text = "";

            foreach (string line in txtInput.Text.Split('\n'))
            {
                if (line.Count(x => x == ';') == 1)
                {
                    string manr = line.Split(';')[0].Trim();
                    string stabsnummer = line.Split(';')[1].ToUpper().Trim();

                    dal.AddParameter("@MANR", manr, System.Data.DbType.String);
                    dal.AddParameter("@Stabsnummer", stabsnummer, System.Data.DbType.String);
                    dal.AddParameter("@Exists", null, System.Data.DbType.Boolean, System.Data.ParameterDirection.Output);
                    dal.AddParameter("@HasOrder", null, System.Data.DbType.Boolean, System.Data.ParameterDirection.Output);
                    dal.AddParameter("@EmployeeId", null, System.Data.DbType.Int32, System.Data.ParameterDirection.Output);
                    dal.AddParameter("@Executor", User.Identity.Name, System.Data.DbType.String);
                    dal.ExecuteStoredProcedure("EmployeeBULKUpdate");

                    bool exists = Convert.ToInt32(dal.GetParameterValue("@Exists")) == 1;
                    bool hasOrder = Convert.ToInt32(dal.GetParameterValue("@HasOrder")) == 1;
                    int employeeId = exists ? Convert.ToInt32(dal.GetParameterValue("@EmployeeId")) : -1;

                    dal.ClearParameters();
                    if (exists)
                    {
                        if (hasOrder)
                            lblOutput.Text += $"<a href=\"/employee/{employeeId}\">{manr}</a> opdateret, har genstande<br />";
                        else
                            lblOutput.Text += $"<a href=\"/employee/{employeeId}\">{manr}</a> opdateret<br />";
                    }
                    else
                        lblOutput.Text += $"{manr} findes ikke<br />";
                }
                else if (line != "")
                    lblOutput.Text += $"Fejl på linje: {line}<br />";
            }
        }
    }
}