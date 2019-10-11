using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class devices : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                DeviceFilter df = GetFilledDeviceFilter();

                sdsDevices.FilterParameters["@IMEI"].DefaultValue = df.IMEIFilter;
                sdsDevices.FilterParameters["@Model"].DefaultValue = df.ModelFilter;
                sdsDevices.FilterParameters["@Provider"].DefaultValue = df.ProviderFilter;
                sdsDevices.FilterParameters["@Unit"].DefaultValue = df.UnitFilter;
                sdsDevices.FilterParameters["@Type"].DefaultValue = df.TypeFilter;
                sdsDevices.FilterParameters["@Status"].DefaultValue = df.StatusFilter;
                sdsDevices.FilterParameters["@TaxType"].DefaultValue = df.TaxTypeFilter;
                sdsDevices.FilterParameters["@Employee"].DefaultValue = df.EmployeeFilter;
                gvDevices.DataBind();

                FillFilters(df);
            }
        }

        protected void gvDevices_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/device/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                //e.Row.Attributes["onClick"] = $"javascript:window.location='{Location}';";
                e.Row.Style["cursor"] = "pointer";
            }
        }
        
        protected void gvDevices_Sorting(object sender, GridViewSortEventArgs e)
        {
            ViewState["df"] = GetFilledDeviceFilter();
        }

        private DeviceFilter GetFilledDeviceFilter()
        {
            return new DeviceFilter
            {
                IMEIFilter = (gvDevices.HeaderRow.FindControl("txtIMEI") as TextBox).Text,
                ProviderFilter = (gvDevices.HeaderRow.FindControl("txtProvider") as TextBox).Text,
                ModelFilter = (gvDevices.HeaderRow.FindControl("txtModel") as TextBox).Text,
                UnitFilter = (gvDevices.HeaderRow.FindControl("ddlUnit") as DropDownList).SelectedValue,
                TypeFilter = (gvDevices.HeaderRow.FindControl("ddlType") as DropDownList).SelectedValue,
                StatusFilter = (gvDevices.HeaderRow.FindControl("ddlStatus") as DropDownList).SelectedValue,
                TaxTypeFilter = (gvDevices.HeaderRow.FindControl("ddlTaxType") as DropDownList).SelectedValue,
                EmployeeFilter = (gvDevices.HeaderRow.FindControl("txtEmployee") as TextBox).Text
            };
        }

        protected void gvDevices_DataBound(object sender, EventArgs e)
        {
            DeviceFilter df = ViewState["df"] as DeviceFilter ?? new DeviceFilter();
            FillFilters(df);

            if (gvDevices.PageCount > 1)
            {
                int maxcount = gvDevices.PageCount * gvDevices.PageSize;
                int mincount = maxcount - gvDevices.PageSize;
                lblRowCount.Text = $"{mincount}-{maxcount} resultater";
            }
            else
            {
                int count = gvDevices.Rows.Count;
                lblRowCount.Text = $"{count} resultat{(count != 1 ? "er" : "")}";
            }
        }

        private void FillFilters(DeviceFilter df)
        {
            ((TextBox)gvDevices.HeaderRow.FindControl("txtIMEI")).Text = df.IMEIFilter;
            ((TextBox)gvDevices.HeaderRow.FindControl("txtModel")).Text = df.ModelFilter;
            ((TextBox)gvDevices.HeaderRow.FindControl("txtProvider")).Text = df.ProviderFilter;
            ((DropDownList)gvDevices.HeaderRow.FindControl("ddlUnit")).SelectedValue = df.UnitFilter;
            ((DropDownList)gvDevices.HeaderRow.FindControl("ddlType")).SelectedValue = df.TypeFilter;
            ((DropDownList)gvDevices.HeaderRow.FindControl("ddlStatus")).SelectedValue = df.StatusFilter;
            ((DropDownList)gvDevices.HeaderRow.FindControl("ddlTaxType")).SelectedValue = df.TaxTypeFilter;
            ((TextBox)gvDevices.HeaderRow.FindControl("txtEmployee")).Text = df.EmployeeFilter;
        }

        protected void gvDevices_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            ViewState["df"] = GetFilledDeviceFilter();
        }
    }

    [Serializable]
    class DeviceFilter
    {
        public string IMEIFilter;
        public string ModelFilter;
        public string ProviderFilter;
        public string UnitFilter;
        public string TypeFilter;
        public string StatusFilter;
        public string TaxTypeFilter;
        public string EmployeeFilter;
    }
}