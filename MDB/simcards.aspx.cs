using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class simcards : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                SimcardFilter sf = GetFilledSimcardFilter();

                sdsSimcards.FilterParameters["@Simnumber"].DefaultValue = sf.SimnumberFilter;
                sdsSimcards.FilterParameters["@Number"].DefaultValue = sf.NumberFilter;
                sdsSimcards.FilterParameters["@Type"].DefaultValue = sf.TypeFilter;
                sdsSimcards.FilterParameters["@Provider"].DefaultValue = sf.ProviderFilter;
                sdsSimcards.FilterParameters["@Unit"].DefaultValue = sf.UnitFilter;
                sdsSimcards.FilterParameters["@Status"].DefaultValue = sf.StatusFilter;
                sdsSimcards.FilterParameters["@TaxType"].DefaultValue = sf.TaxTypeFilter;
                sdsSimcards.FilterParameters["@Employee"].DefaultValue = sf.EmployeeFilter;
                gvSimcards.DataBind();

                FillFilters(sf);
            }
        }

        protected void gvSimcards_DataBound(object sender, EventArgs e)
        {
            SimcardFilter sf = ViewState["sf"] as SimcardFilter ?? new SimcardFilter();
            FillFilters(sf);

            if (gvSimcards.PageCount > 1)
            {
                int maxcount = gvSimcards.PageCount * gvSimcards.PageSize;
                int mincount = maxcount - gvSimcards.PageSize;
                lblRowCount.Text = $"{mincount}-{maxcount} resultater";
            }
            else
            {
                int count = gvSimcards.Rows.Count;
                lblRowCount.Text = $"{count} resultat{(count != 1 ? "er" : "")}";
            }
        }

        private SimcardFilter GetFilledSimcardFilter()
        {
            return new SimcardFilter
            {
                SimnumberFilter = (gvSimcards.HeaderRow.FindControl("txtSimnumber") as TextBox).Text,
                NumberFilter = (gvSimcards.HeaderRow.FindControl("txtNumber") as TextBox).Text,
                TypeFilter = (gvSimcards.HeaderRow.FindControl("ddlType") as DropDownList).SelectedValue,
                ProviderFilter = (gvSimcards.HeaderRow.FindControl("txtProvider") as TextBox).Text,
                UnitFilter = (gvSimcards.HeaderRow.FindControl("ddlUnit") as DropDownList).SelectedValue,
                StatusFilter = (gvSimcards.HeaderRow.FindControl("ddlStatus") as DropDownList).SelectedValue,
                TaxTypeFilter = (gvSimcards.HeaderRow.FindControl("ddlTaxType") as DropDownList).SelectedValue,
                EmployeeFilter = (gvSimcards.HeaderRow.FindControl("txtEmployee") as TextBox).Text
            };
        }

        protected void gvSimcards_Sorting(object sender, GridViewSortEventArgs e)
        {
            ViewState["sf"] = GetFilledSimcardFilter();
        }

        protected void gvSimcards_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/simcard/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                e.Row.Style["cursor"] = "pointer";
            }
        }

        private void FillFilters(SimcardFilter sf)
        {
            ((TextBox)gvSimcards.HeaderRow.FindControl("txtSimnumber")).Text = sf.SimnumberFilter;
            ((TextBox)gvSimcards.HeaderRow.FindControl("txtNumber")).Text = sf.NumberFilter;
            ((DropDownList)gvSimcards.HeaderRow.FindControl("ddlType")).SelectedValue = sf.TypeFilter;
            ((TextBox)gvSimcards.HeaderRow.FindControl("txtProvider")).Text = sf.ProviderFilter;
            ((DropDownList)gvSimcards.HeaderRow.FindControl("ddlUnit")).SelectedValue = sf.UnitFilter;
            ((DropDownList)gvSimcards.HeaderRow.FindControl("ddlStatus")).SelectedValue = sf.StatusFilter;
            ((DropDownList)gvSimcards.HeaderRow.FindControl("ddlTaxType")).SelectedValue = sf.TaxTypeFilter;
            ((TextBox)gvSimcards.HeaderRow.FindControl("txtEmployee")).Text = sf.EmployeeFilter;
        }

        protected void gvSimcards_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ViewState["sf"] = GetFilledSimcardFilter();
        }
    }

    [Serializable]
    class SimcardFilter
    {
        public string SimnumberFilter;
        public string NumberFilter;
        public string TypeFilter;
        public string ProviderFilter;
        public string UnitFilter;
        public string StatusFilter;
        public string TaxTypeFilter;
        public string EmployeeFilter;
    }
}