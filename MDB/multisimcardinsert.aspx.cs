using MDB.AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class multisimcardinsert : System.Web.UI.Page
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

            gvSimcards.DataSource = noOfRows;
            gvSimcards.DataBind();
            btnInsert.Visible = noOfRows != null;
        }

        protected void gvSimcards_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string rowIndex = (e.Row.RowIndex + 1).ToString();

                TextBox txtSimnumber = (TextBox)e.Row.FindControl("txtSimnumber");
                txtSimnumber.Attributes.Add("data-type", "identifier");
                txtSimnumber.Attributes.Add("data-row-index", rowIndex);
                txtSimnumber.Attributes.Add("OnBlur", $"ShowAvailability(this,4,true)");

                TextBox txtPUK = (TextBox)e.Row.FindControl("txtPUK");
                txtPUK.Attributes.Add("data-type", "");
                txtPUK.Attributes.Add("data-col", "puk");
                txtPUK.Attributes.Add("data-row-index", rowIndex);

                TextBox txtNumber = (TextBox)e.Row.FindControl("txtNumber");
                txtNumber.Attributes.Add("data-type", "");
                txtNumber.Attributes.Add("data-col", "number");
                txtNumber.Attributes.Add("data-row-index", rowIndex);

                DropDownList ddlFormat = (DropDownList)e.Row.FindControl("ddlFormat");
                ddlFormat.Attributes.Add("data-type", "fill");
                ddlFormat.Attributes.Add("data-col", "format");
                ddlFormat.Attributes.Add("data-row-index", rowIndex);

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
            }
        }
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            Validate();

            if (Page.IsValid && gvSimcards.Rows.Count > 1)
            {
                List<SimcardWithResult> results = new List<SimcardWithResult>();

                foreach (GridViewRow row in gvSimcards.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        string simnumber = ((TextBox)row.FindControl("txtSimnumber")).Text.Trim();

                        if (simnumber != "")
                        {
                            SimcardWithResult d = (SimcardWithResult)AppCode.Simcard.GetSimcard(simnumber);

                            if (d == null)
                            {
                                d = new SimcardWithResult
                                {
                                    Simnumber = simnumber,
                                    PUK = ((TextBox)row.FindControl("txtPUK")).Text,
                                    Number = ((TextBox)row.FindControl("txtNumber")).Text,
                                    IsData = false,//Ikke implementeret
                                    FormatId = int.Parse(((DropDownList)row.FindControl("ddlFormat")).SelectedValue),
                                    QuotaId = 1,//Ikke implementeret
                                    DataPlanId = 1,//Ikke implementeret
                                    Provider = ((TextBox)row.FindControl("txtProvider")).Text,
                                    UnitId = int.Parse(((DropDownList)row.FindControl("ddlUnit")).SelectedValue),
                                    OrderNumber = ((TextBox)row.FindControl("txtOrderNumber")).Text
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
            TextBox txtSimnumber = (TextBox)cv.NamingContainer.FindControl("txtSimnumber");
            e.IsValid = (txtSimnumber.Text.Trim() == "" || e.Value != "");
        }

        protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/simcard/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                e.Row.Style["cursor"] = "pointer";
            }
        }
    }
}