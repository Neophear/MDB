using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MDB.AppCode;
using MDB.Controls;
using Stiig;

namespace MDB
{
    public partial class multideviceinsert : System.Web.UI.Page
    {
        protected int maxLines = 50;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMaxLines.Text = $"Der kan maks genereres {maxLines} linjer.";
                txtNumberOfRows.Text = "10";
                AddRowsToGrid();
            }
        }

        protected void btnGenerateLines_Click(object sender, EventArgs e)
        {
            AddRowsToGrid();
        }

        private void AddRowsToGrid()
        {
            List<int> noOfRows = null;
            if (int.TryParse(txtNumberOfRows.Text.Trim(), out int rows) && rows > 0 && rows <= maxLines)
            {
                noOfRows = new List<int>();
                for (int i = 0; i < rows; i++)
                    noOfRows.Add(i);
            }

            gvDevices.DataSource = noOfRows;
            gvDevices.DataBind();
            btnInsert.Visible = noOfRows != null;
        }

        protected void gvDevices_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string rowIndex = (e.Row.RowIndex + 1).ToString();

                TextBox txtIMEI = (TextBox)e.Row.FindControl("txtIMEI");
                txtIMEI.Attributes.Add("data-type", "identifier");
                txtIMEI.Attributes.Add("data-row-index", rowIndex);
                txtIMEI.Attributes.Add("OnBlur", $"ShowAvailability(this,3,true)");

                TextBox txtModel = (TextBox)e.Row.FindControl("txtModel");
                txtModel.Attributes.Add("data-type", "fill");
                txtModel.Attributes.Add("data-col", "model");
                txtModel.Attributes.Add("data-row-index", rowIndex);

                TextBox txtProvider = (TextBox)e.Row.FindControl("txtProvider");
                txtProvider.Attributes.Add("data-type", "fill");
                txtProvider.Attributes.Add("data-col", "provider");
                txtProvider.Attributes.Add("data-row-index", rowIndex);

                TextBox txtOrderNumber = (TextBox)e.Row.FindControl("txtOrderNumber");
                txtOrderNumber.Attributes.Add("data-type", "fill");
                txtOrderNumber.Attributes.Add("data-col", "ordernumber");
                txtOrderNumber.Attributes.Add("data-row-index", rowIndex);

                TextBox txtBuyDate = (TextBox)e.Row.FindControl("txtBuyDate");
                txtBuyDate.Attributes.Add("data-type", "fill");
                txtBuyDate.Attributes.Add("data-col", "buydate");
                txtBuyDate.Attributes.Add("data-row-index", rowIndex);

                DropDownList ddlUnit = (DropDownList)e.Row.FindControl("ddlUnit");
                ddlUnit.Attributes.Add("data-type", "fill");
                ddlUnit.Attributes.Add("data-col", "unit");
                ddlUnit.Attributes.Add("data-row-index", rowIndex);

                DropDownList ddlType = (DropDownList)e.Row.FindControl("ddlType");
                ddlType.Attributes.Add("data-type", "fill");
                ddlType.Attributes.Add("data-col", "type");
                ddlType.Attributes.Add("data-row-index", rowIndex);
            }
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            Validate();

            if (Page.IsValid && gvDevices.Rows.Count > 1)
            {
                List<DeviceWithResult> results = new List<DeviceWithResult>();

                foreach (GridViewRow row in gvDevices.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        string imei = ((TextBox)row.FindControl("txtIMEI")).Text.Trim();

                        if (imei != "")
                        {
                            DeviceWithResult d = (DeviceWithResult)AppCode.Device.GetDevice(imei);

                            if (d == null)
                            {
                                d = new DeviceWithResult
                                {
                                    IMEI = imei,
                                    Model = ((TextBox)row.FindControl("txtModel")).Text,
                                    Provider = ((TextBox)row.FindControl("txtProvider")).Text,
                                    OrderNumber = ((TextBox)row.FindControl("txtOrderNumber")).Text,
                                    UnitId = int.Parse(((DropDownList)row.FindControl("ddlUnit")).SelectedValue),
                                    TypeId = int.Parse(((DropDownList)row.FindControl("ddlType")).SelectedValue)
                                };

                                string buyDate = ((TextBox)row.FindControl("txtBuyDate")).Text;
                                if (buyDate.Trim() != "")
                                    d.BuyDate = DateTime.Parse(buyDate);

                                if (d.Save())
                                    d.Result = "Oprettet";
                                else
                                    d.Result = "Noget gik galt";
                            }
                            else
                                d.Result = "Findes i forvejen";

                            results.Add(d);
                        }
                    }
                }

                gvResult.DataSource = results;
                gvResult.DataBind();

                AddRowsToGrid();
            }
        }

        protected void cv_ServerValidate(object sender, ServerValidateEventArgs e)
        {
            CustomValidator cv = (CustomValidator)sender;
            TextBox txtIMEI = (TextBox)cv.NamingContainer.FindControl("txtIMEI");
            e.IsValid = (txtIMEI.Text.Trim() == "" || e.Value != "");
        }

        protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/device/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                e.Row.Style["cursor"] = "pointer";
            }
        }
    }
}