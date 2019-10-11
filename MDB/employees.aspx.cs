using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class employees : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                EmployeeFilter df = GetFilledEmployeeFilter();

                sdsEmployees.FilterParameters["@MANR"].DefaultValue = df.MANRFilter;
                sdsEmployees.FilterParameters["@Stabsnummer"].DefaultValue = df.StabsnummerFilter;
                sdsEmployees.FilterParameters["@Name"].DefaultValue = df.NameFilter;
                gvEmployees.DataBind();

                FillFilters(df);
            }
        }

        private void FillFilters(EmployeeFilter ef)
        {
            (gvEmployees.HeaderRow.FindControl("txtMANR") as TextBox).Text = ef.MANRFilter;
            (gvEmployees.HeaderRow.FindControl("txtStabsnummer") as TextBox).Text = ef.StabsnummerFilter;
            (gvEmployees.HeaderRow.FindControl("txtName") as TextBox).Text = ef.NameFilter;
        }

        private EmployeeFilter GetFilledEmployeeFilter()
        {
            return new EmployeeFilter
            {
                MANRFilter = (gvEmployees.HeaderRow.FindControl("txtMANR") as TextBox).Text,
                StabsnummerFilter = (gvEmployees.HeaderRow.FindControl("txtStabsnummer") as TextBox).Text,
                NameFilter = (gvEmployees.HeaderRow.FindControl("txtName") as TextBox).Text,
            };
        }

        protected void gvEmployees_DataBound(object sender, EventArgs e)
        {
            EmployeeFilter ef = ViewState["ef"] as EmployeeFilter ?? new EmployeeFilter();
            FillFilters(ef);

            if (gvEmployees.PageCount > 1)
            {
                int maxcount = gvEmployees.PageCount * gvEmployees.PageSize;
                int mincount = maxcount - gvEmployees.PageSize;
                lblRowCount.Text = $"{mincount}-{maxcount} resultater";
            }
            else
            {
                int count = gvEmployees.Rows.Count;
                lblRowCount.Text = $"{count} resultat{(count != 1 ? "er" : "")}";
            }
        }

        protected void gvEmployees_Sorting(object sender, GridViewSortEventArgs e)
        {
            ViewState["ef"] = GetFilledEmployeeFilter();
        }

        protected void gvEmployees_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ViewState["ef"] = GetFilledEmployeeFilter();
        }

        protected void gvEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/employee/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                e.Row.Style["cursor"] = "pointer";
            }
        }
    }

    [Serializable]
    class EmployeeFilter
    {
        public string MANRFilter;
        public string StabsnummerFilter;
        public string NameFilter;
    }
}