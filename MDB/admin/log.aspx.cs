using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB.admin
{
    public partial class log : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDateFrom.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtDateTo.Text = DateTime.Today.ToString("yyyy-MM-dd");

                sdsLog.SelectParameters["DateFrom"].DefaultValue = DateTime.Today.ToShortDateString();
                sdsLog.SelectParameters["DateTo"].DefaultValue = DateTime.Today.ToShortDateString();
                sdsLog.SelectParameters["Executor"].DefaultValue = String.Empty;
                sdsLog.SelectParameters["SearchTerm"].DefaultValue = String.Empty;
            }

            if (!chkbxWithDates.Checked)
            {
                txtDateFrom.Attributes.Add("hidden", "");
                txtDateTo.Attributes.Add("hidden", "");
            }
            else
            {
                txtDateFrom.Attributes.Remove("hidden");
                txtDateTo.Attributes.Remove("hidden");
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
                    sdsLog.SelectParameters["DateFrom"].DefaultValue = dateFrom.ToShortDateString();
                    sdsLog.SelectParameters["DateTo"].DefaultValue = dateTo.ToShortDateString();
                }
            }
            else
            {
                sdsLog.SelectParameters["DateFrom"].DefaultValue = null;
                sdsLog.SelectParameters["DateTo"].DefaultValue = null;
            }

            sdsLog.SelectParameters["Executor"].DefaultValue = chkbxOnlyCurrentUser.Checked ? User.Identity.Name : String.Empty;
            sdsLog.SelectParameters["SearchTerm"].DefaultValue = searchTerm;
        }

        private void ShowError(string msg)
        {
            lblError.Text = msg;
            lblError.Visible = true;
        }

        protected void gvLog_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && (int)DataBinder.Eval(e.Row.DataItem, "ActionRefId") != 3)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "ObjectId");
                string Location = "";

                switch ((int)DataBinder.Eval(e.Row.DataItem, "ObjectTypeId"))
                {
                    case 2:
                        Location = ResolveUrl("~/employee/") + Id;
                        break;
                    case 3:
                        Location = ResolveUrl("~/device/") + Id;
                        break;
                    case 4:
                        Location = ResolveUrl("~/simcard/") + Id;
                        break;
                    case 5:
                        Location = ResolveUrl("~/order/") + Id;
                        break;
                    case 8:
                        Location = ResolveUrl("~/admin/news/") + Id;
                        break;
                    case 10:
                        Location = ResolveUrl("~/comment/") + Id;
                        break;
                    default:
                        break;
                }

                if (Location != "")
                {
                    e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                    //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                    e.Row.Style["cursor"] = "pointer";
                }
            }
        }
    }
}