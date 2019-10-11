using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB
{
    public partial class multiemployeeinsert : System.Web.UI.Page
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

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string rowIndex = (e.Row.RowIndex + 1).ToString();

                TextBox txtMANR = (TextBox)e.Row.FindControl("txtMANR");
                txtMANR.Attributes.Add("data-type", "identifier");
                txtMANR.Attributes.Add("data-row-index", rowIndex);
                txtMANR.Attributes.Add("OnBlur", $"ShowAvailability(this,2,true)");

                TextBox txtStabsnummer = (TextBox)e.Row.FindControl("txtStabsnummer");
                txtStabsnummer.Attributes.Add("data-type", "fill");
                txtStabsnummer.Attributes.Add("data-col", "stabsnummer");
                txtStabsnummer.Attributes.Add("data-row-index", rowIndex);

                TextBox txtName = (TextBox)e.Row.FindControl("txtName");
                txtName.Attributes.Add("data-type", "fill");
                txtName.Attributes.Add("data-col", "name");
                txtName.Attributes.Add("data-row-index", rowIndex);

                CheckBox chkbxSignedSolemnDeclaration = (CheckBox)e.Row.FindControl("chkbxSignedSolemnDeclaration");
                chkbxSignedSolemnDeclaration.Attributes.Add("data-type", "fill");
                chkbxSignedSolemnDeclaration.Attributes.Add("data-col", "signedsolemndeclaration");
                chkbxSignedSolemnDeclaration.Attributes.Add("data-row-index", rowIndex);

                TextBox txtNotes = (TextBox)e.Row.FindControl("txtNotes");
                txtNotes.Attributes.Add("data-type", "fill");
                txtNotes.Attributes.Add("data-col", "notes");
                txtNotes.Attributes.Add("data-row-index", rowIndex);
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

            gvUsers.DataSource = noOfRows;
            gvUsers.DataBind();
            btnInsert.Visible = noOfRows != null;
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            Validate();

            if (Page.IsValid && gvUsers.Rows.Count > 1)
            {
                List<EmployeeWithResult> results = new List<EmployeeWithResult>();

                foreach (GridViewRow row in gvUsers.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        string manr = ((TextBox)row.FindControl("txtMANR")).Text.Trim();

                        if (manr != "")
                        {
                            EmployeeWithResult d = (EmployeeWithResult)AppCode.Employee.GetEmployee(manr);

                            if (d == null)
                            {
                                d = new EmployeeWithResult
                                {
                                    MANR = manr,
                                    Stabsnummer = ((TextBox)row.FindControl("txtStabsnummer")).Text,
                                    Name = ((TextBox)row.FindControl("txtName")).Text,
                                    SignedSolemnDeclaration = ((CheckBox)row.FindControl("chkbxSignedSolemnDeclaration")).Checked,
                                    Notes = ((TextBox)row.FindControl("txtNotes")).Text
                                };

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
            TextBox txtMANR = (TextBox)cv.NamingContainer.FindControl("txtMANR");
            e.IsValid = (txtMANR.Text.Trim() == "" || e.Value != "");
        }

        protected void gvResult_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                int Id = (int)DataBinder.Eval(e.Row.DataItem, "Id");
                string Location = ResolveUrl("~/employee/") + Id;
                e.Row.Attributes["onmouseup"] = $"return NavigateTo(event,'{Location}')";
                e.Row.Style["cursor"] = "pointer";
            }
        }

        protected class EmployeeWithResult : AppCode.Employee
        {
            public string Result { get; set; }
        }
    }
}