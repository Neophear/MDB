using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB.admin
{
    public partial class userlog : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDateFrom.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtDateTo.Text = DateTime.Today.ToString("yyyy-MM-dd");

                sdsLog.SelectParameters["DateFrom"] = new Parameter("DateFrom", System.Data.DbType.Date, DateTime.Today.ToShortDateString());
                sdsLog.SelectParameters["DateTo"] = new Parameter("DateTo", System.Data.DbType.Date, DateTime.Today.ToShortDateString());
                sdsLog.SelectParameters["Executor"] = new Parameter("Executor", System.Data.DbType.String, String.Empty);
                sdsLog.SelectParameters["SearchTerm"] = new Parameter("SearchTerm", System.Data.DbType.String, String.Empty);
            }
        }

        protected void btnLoadLog_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearchTerm.Text;

            if (chkbxWithDates.Checked)
            {
                DateTime dateFrom = DateTime.Parse(txtDateFrom.Text);
                DateTime dateTo = DateTime.Parse(txtDateTo.Text);

                txtDateFrom.Text = dateFrom.ToString("yyyy-MM-dd");
                txtDateTo.Text = dateTo.ToString("yyyy-MM-dd");

                if (dateFrom > dateTo)
                    ShowError("Slutdatoen kan ikke komme før startdatoen");
                else
                {
                    sdsLog.SelectParameters["DateFrom"] = new Parameter("DateFrom", System.Data.DbType.Date, dateFrom.ToShortDateString());
                    sdsLog.SelectParameters["DateTo"] = new Parameter("DateTo", System.Data.DbType.Date, dateTo.ToShortDateString());
                }
            }
            else
            {
                sdsLog.SelectParameters["DateFrom"] = new Parameter("DateFrom", System.Data.DbType.Date, null);
                sdsLog.SelectParameters["DateTo"] = new Parameter("DateTo", System.Data.DbType.Date, null);
            }

            sdsLog.SelectParameters["Executor"] = new Parameter("Executor", System.Data.DbType.String, chkbxOnlyCurrentUser.Checked ? User.Identity.Name : String.Empty);
            sdsLog.SelectParameters["SearchTerm"] = new Parameter("SearchTerm", System.Data.DbType.String, searchTerm);
        }

        private void ShowError(string msg)
        {
            lblError.Text = msg;
            lblError.Visible = true;
        }
    }
}