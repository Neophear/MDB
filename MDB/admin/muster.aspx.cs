using MDB.AppCode;
using MDB.Controls;
using OfficeOpenXml;
using Stiig;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MDB.admin
{
    public partial class muster : System.Web.UI.Page
    {
        List<MusterLine> musterLines;
        Dictionary<int, string> taxTypes;

        protected void Page_Load(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();
            DataTable table = dal.ExecuteDataTable("SELECT [Id], [Name] FROM [TaxTypes]");

            taxTypes = new Dictionary<int, string>(table.Rows.Count);

            foreach (DataRow row in table.Rows)
                taxTypes.Add((int)row["Id"], (string)row["Name"]);
        }

        public void SetMessage(string message, bool isError = false)
        {
            lblMusterMsg.Text = message;
            lblMusterMsg.Visible = true;
            lblMusterMsg.CssClass = isError ? "error" : "";
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (fuFile.HasFile)
            {
                string ext = Path.GetExtension(fuFile.FileName).ToLower();

                if (ext != ".xlsx")
                    SetMessage("Filen er ikke en XLSX-fil", true);
                else if (fuFile.FileContent.Length > 2000000)
                    SetMessage("Filen er over 2MB", true);
                else
                {
                    string localPath = Server.MapPath("~/Files/TEMP/");

                    if (!Directory.Exists(localPath))
                        Directory.CreateDirectory(localPath);

                    string filename = $"{DateTime.Now.ToString("yyyyMMddHHmmss")}{User.Identity.Name}.{ext}";
                    string filepath = localPath + filename;
                    fuFile.SaveAs(filepath);

                    ReadExcel(filepath);

                    WriteOutput();
                }
            }
            else
                SetMessage("Kunne ikke finde filen", true);
        }

        private void WriteOutput()
        {
            gvInput.DataSource = musterLines;
            gvInput.DataBind();

            btnInsertMuster.Visible = gvInput.Rows.Count > 0;
        }

        private void ReadExcel(string filepath)
        {
            var package = new ExcelPackage(new FileInfo(filepath));

            ExcelWorksheet ws = package.Workbook.Worksheets[1];

            if (!CheckColumnNames(ws))
                SetMessage("Excel-arket er ikke validt", true);
            else
            {
                musterLines = new List<MusterLine>(ws.Dimension.End.Row - 1);

                for (int i = 2; i <= ws.Dimension.End.Row; i++)
                {
                    MusterLine line = new MusterLine(
                        i,                   //line
                        ws.Cells[i, 1].Text, //manr
                        ws.Cells[i, 2].Text, //stabsnummer
                        ws.Cells[i, 3].Text, //name
                        ws.Cells[i, 4].Text, //imei
                        ws.Cells[i, 5].Text, //simcard
                        taxTypes.FirstOrDefault(x => x.Value.ToLower() == ws.Cells[i, 6].Text.ToLower())
                    );

                    //List<MusterLine> duplicates = musterLines.FindAll(
                    //    x => x.Device == line.Device
                    //    || x.Simcard == line.Simcard);

                    //foreach (MusterLine dup in duplicates)
                    //{
                    //    if (dup.Device == line.Device)
                    //        line.IMEI.Message = $"IMEI fremgår allerede på linje {dup.Line}";

                    //    if (dup.Simcard == line.Simcard)
                    //        line.SIMnumber.Message = $"SIM-nummer fremgår allerede på linje {dup.Line}";
                    //}

                    musterLines.Add(line);
                }
            }
        }

        private bool CheckColumnNames(ExcelWorksheet ws)
        {
            return ws.Cells["A1"].Text.StartsWith("MANR")
                && ws.Cells["B1"].Text.StartsWith("Stabsnummer")
                && ws.Cells["C1"].Text.StartsWith("Navn")
                && ws.Cells["D1"].Text.StartsWith("IMEI")
                && ws.Cells["E1"].Text.StartsWith("SIM-nummer")
                && ws.Cells["F1"].Text.StartsWith("Beskatning");
        }

        protected void cv_ServerValidate(object sender, ServerValidateEventArgs e)
        {
            CustomValidator cv = (CustomValidator)sender;
            string manr = ((TextBoxWithOptions)cv.NamingContainer.FindControl("tbwoMANR")).Text;
            e.IsValid = (manr.Trim() == "" || e.Value != "");
        }

        protected void gvInput_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ((DropDownList)e.Row.FindControl("ddlTaxType")).SelectedValue = ((KeyValuePair<int, string>)DataBinder.Eval(e.Row.DataItem, "TaxType")).Key.ToString();

                string rowIndex = DataBinder.Eval(e.Row.DataItem, "Line").ToString();

                TextBox txtMANR = (TextBox)e.Row.FindControl("tbwoMANR").FindControl("txt");
                txtMANR.Attributes.Add("data-type", "identifier");
                txtMANR.Attributes.Add("data-row-index", rowIndex);
                txtMANR.Attributes.Add("OnBlur", $"MusterCheckSubject(this)");

                TextBox tbwoStabsnummer = (TextBox)e.Row.FindControl("tbwoStabsnummer").FindControl("txt");
                tbwoStabsnummer.Attributes.Add("data-row-index", rowIndex);

                TextBox tbwoName = (TextBox)e.Row.FindControl("tbwoName").FindControl("txt");
                tbwoName.Attributes.Add("data-row-index", rowIndex);

                DropDownList ddlTaxType = (DropDownList)e.Row.FindControl("ddlTaxType");
                ddlTaxType.Attributes.Add("data-row-index", rowIndex);
            }
        }

        protected void btnInsertMuster_Click(object sender, EventArgs e)
        {
            Validate("muster");

            if (Page.IsValid && gvInput.Rows.Count > 1)
            {
                DataAccessLayer dal = new DataAccessLayer();
                List<string> results = new List<string>(gvInput.Rows.Count);

                foreach (GridViewRow row in gvInput.Rows)
                {
                    if (row.RowType != DataControlRowType.DataRow)
                        break;

                    StringBuilder result = new StringBuilder();
                    result.Append($"Linje {row.Cells[0].Text}");

                    int taxTypeId = -1;

                    int.TryParse(((DropDownList)row.FindControl("ddlTaxType")).SelectedValue, out taxTypeId);

                    string imei = ((HiddenField)((DeviceMusterInfo)row.FindControl("dhiDevice")).FindControl("hdnIMEI")).Value;
                    string simnumber = ((HiddenField)((SimcardMusterInfo)row.FindControl("shiSimcard")).FindControl("hdnSimnumber")).Value;
                    string manr = ((TextBoxWithOptions)row.FindControl("tbwoMANR")).Text.Trim();
                    string stabsnummer = ((TextBoxWithOptions)row.FindControl("tbwoStabsnummer")).Text.Trim();
                    string name = ((TextBoxWithOptions)row.FindControl("tbwoName")).Text.Trim();

                    if (String.IsNullOrWhiteSpace(manr) && !chkbxStorageIfEmptyMANR.Checked)
                        result.Append(" Intet MANR!");
                    else
                    {
                        if (!String.IsNullOrWhiteSpace(imei))
                        {
                            if (Device.GetDevice(imei) is Device device)
                            {
                                dal.AddParameter("@ObjectTypeRefId", 3, DbType.Int16);
                                dal.AddParameter("@ObjectRefId", device.Id, DbType.Int32);
                                dal.AddParameter("@TaxTypeRefId", manr == "" ? null : (int?)taxTypeId, DbType.Int16);
                                dal.AddParameter("@MANR", manr == "" ? null : manr, DbType.String);
                                dal.AddParameter("@Stabsnummer", manr == "" ? null : stabsnummer, DbType.String);
                                dal.AddParameter("@Name", manr == "" ? null : name, DbType.String);
                                dal.AddParameter("@StatusRefId", manr == "" ? "1" : "4", DbType.Int16);
                                dal.AddParameter("@Notes", $"Mønstring {DateTime.Today.ToString("yyyyMMdd")}", DbType.String);
                                dal.AddParameter("@Executor", User.Identity.Name, DbType.String);
                                dal.ExecuteStoredProcedure("OrderInsert");
                                dal.ClearParameters();
                                result.Append($" IMEI OK!");
                            }
                            else
                                result.Append($" IMEI {imei} findes ikke!");
                        }

                        if (!String.IsNullOrWhiteSpace(simnumber))
                        {
                            if (Simcard.GetSimcard(simnumber) is Simcard simcard)
                            {
                                dal.AddParameter("@ObjectTypeRefId", 4, DbType.Int16);
                                dal.AddParameter("@ObjectRefId", simcard.Id, DbType.Int32);
                                dal.AddParameter("@TaxTypeRefId", manr == "" ? null : (int?)taxTypeId, DbType.Int16);
                                dal.AddParameter("@MANR", manr == "" ? null : manr, DbType.String);
                                dal.AddParameter("@Stabsnummer", manr == "" ? null : stabsnummer, DbType.String);
                                dal.AddParameter("@Name", manr == "" ? null : name, DbType.String);
                                dal.AddParameter("@StatusRefId", manr == "" ? "7" : "9", DbType.Int16);
                                dal.AddParameter("@Notes", $"Mønstring {DateTime.Today.ToString("yyyyMMdd")}", DbType.String);
                                dal.AddParameter("@Executor", User.Identity.Name, DbType.String);
                                dal.ExecuteStoredProcedure("OrderInsert");
                                dal.ClearParameters();
                                result.Append($" SIM OK!");
                            }
                            else
                                result.Append($" SIM {simnumber} findes ikke!");
                        }
                    }
                    
                    results.Add(result.ToString());
                }

                txtResult.Text = "";
                txtResult.Visible = true;

                foreach (String line in results)
                    txtResult.Text += $"{line}\n";

                SetMessage("<br />Rækker kørt!<br /><br/>");
                btnInsertMuster.Visible = false;
            }
        }
    }
}