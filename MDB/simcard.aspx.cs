using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class simcard : Page
    {
        private int objectId = -1;
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            if (Page.RouteData.Values["id"] != null)
                objectId = int.Parse(Page.RouteData.Values["id"].ToString());

            if (!IsPostBack)
            {
                if (objectId == -1)
                {
                    dvSimcard.ChangeMode(DetailsViewMode.Insert);
                    gvOrders.Enabled = false;
                }
                else
                {
                    ShowLog.ObjectId = objectId;
                    ShowLog.ObjectTypeId = 4;
                    Comments.ObjectId = objectId;
                    Comments.ObjectTypeId = 4;
                }
            }

            ShowLog.Visible = User.IsInRole("Admin") && objectId != -1;
            Page.Title = objectId == -1 ? "Nyt SIM-kort" : $"SIM-kort {objectId}";
        }

        protected void dvSimcard_DataBound(object sender, EventArgs e)
        {
            if (dvSimcard.CurrentMode == DetailsViewMode.Edit)
            {
                //((RadioButtonList)dvSimcard.FindControl("rblIsData")).SelectedValue = DataBinder.Eval(dvSimcard.DataItem, "IsData").ToString();
                ((DropDownList)dvSimcard.FindControl("ddlFormat")).SelectedValue = DataBinder.Eval(dvSimcard.DataItem, "FormatRefId").ToString();
                ((DropDownList)dvSimcard.FindControl("ddlQuota")).SelectedValue = DataBinder.Eval(dvSimcard.DataItem, "QuotaRefId").ToString();
                ((DropDownList)dvSimcard.FindControl("ddlDataPlan")).SelectedValue = DataBinder.Eval(dvSimcard.DataItem, "DataPlanRefId").ToString();
                ((DropDownList)dvSimcard.FindControl("ddlUnit")).SelectedValue = DataBinder.Eval(dvSimcard.DataItem, "UnitRefId").ToString();

                foreach (DetailsViewRow row in dvSimcard.Rows)
                    if (row.Cells[0].Text == "Status")
                        row.Visible = false;
            }

            if (dvSimcard.CurrentMode != DetailsViewMode.ReadOnly)
            {
                ((TextBox)dvSimcard.FindControl("txtBuyDate")).Attributes.Add("readonly", "readonly");
                ((TextBox)dvSimcard.FindControl("txtQuotaEndDate")).Attributes.Add("readonly", "readonly");

                if (((DropDownList)dvSimcard.FindControl("ddlQuota")).SelectedIndex == 0)
                    ((TextBox)dvSimcard.FindControl("txtQuotaEndDate")).Style.Add("display", "none");
            }

            dvSimcard.Rows[dvSimcard.Rows.Count - 1].Visible = AppCode.Globals.CanUserWrite();
            pnlInsertOrder.Visible = AppCode.Globals.CanUserWrite() && dvSimcard.CurrentMode == DetailsViewMode.ReadOnly;
        }

        protected void sdsSimcard_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;

            if (e.Command.CommandText == "SimcardInsert" || e.Command.CommandText == "SimcardUpdate")
            {
                //e.Command.Parameters["@IsData"].Value = bool.Parse(((RadioButtonList)dvSimcard.FindControl("rblIsData")).SelectedValue);
                e.Command.Parameters["@FormatRefId"].Value = ((DropDownList)dvSimcard.FindControl("ddlFormat")).SelectedValue;
                e.Command.Parameters["@QuotaRefId"].Value = ((DropDownList)dvSimcard.FindControl("ddlQuota")).SelectedValue;
                e.Command.Parameters["@DataPlanRefId"].Value = ((DropDownList)dvSimcard.FindControl("ddlDataPlan")).SelectedValue;
                e.Command.Parameters["@UnitRefId"].Value = ((DropDownList)dvSimcard.FindControl("ddlUnit")).SelectedValue;

                if (((DropDownList)dvSimcard.FindControl("ddlQuota")).SelectedIndex == 0)
                    e.Command.Parameters["@QuotaEndDate"].Value = null;
            }
        }

        void SetMessage(string m, bool e = true)
        {
            lblMessage.Text = m;
            lblMessage.CssClass = e ? "error" : "";
            lblMessage.Visible = true;
        }

        protected void lnkbtnStatusStorage_Click(object sender, EventArgs e)
        {
            OrderInsert(true);
        }

        private void OrderInsert(bool storage = false)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@ObjectTypeRefId", 4, DbType.Int16);
            dal.AddParameter("@ObjectRefId", Page.RouteData.Values["id"], DbType.Int32);
            dal.AddParameter("@TaxTypeRefId", trTaxType.Visible ? ddlTaxType.SelectedValue : null, DbType.Int16);
            dal.AddParameter("@MANR", trAssignedMANR.Visible ? txtAssignedMANR.Text : null, DbType.String);
            dal.AddParameter("@Stabsnummer", trAssignedMANR.Visible ? txtAssignedStabsnummer.Text : null, DbType.String);
            dal.AddParameter("@Name", trAssignedMANR.Visible ? txtAssignedName.Text : null, DbType.String);
            dal.AddParameter("@StatusRefId", storage ? "7" : ddlStatus.SelectedValue, DbType.Int16);
            dal.AddParameter("@Notes", txtOrderNotes.Text, DbType.String);
            dal.AddParameter("@Executor", User.Identity.Name, DbType.String);
            dal.ExecuteStoredProcedure("OrderInsert");
            dal.ClearParameters();

            Server.TransferRequest(Request.Url.AbsolutePath, false);
        }

        protected void btnInsertOrder_Click(object sender, EventArgs e)
        {
            OrderInsert();
        }

        protected void dvSimcard_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            e.Cancel = SimcardExists(e.Values["Simnumber"].ToString());
        }

        protected void dvSimcard_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            e.Cancel = SimcardExists(e.NewValues["Simnumber"].ToString(), (int)e.Keys["Id"]);
        }

        private bool SimcardExists(string simnumber, int? id = null)
        {
            bool result = AppCode.Functions.CheckIfObjectExists(simnumber, AppCode.Functions.ObjectType.Simcard, id);
            if (result)
                SetMessage("SIMkort-nummer findes i forvejen");
            return result;
        }

        protected void sdsSimcard_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect("~/simcards");
        }

        protected void sdsSimcard_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect($"~/simcard/{e.Command.Parameters["@LastId"].Value}");
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool needEmployee = false;

            if (!String.IsNullOrWhiteSpace(ddlStatus.SelectedValue))
            {
                DataAccessLayer dal = new DataAccessLayer();
                dal.AddParameter("@Id", ddlStatus.SelectedValue, DbType.Int16);
                needEmployee = (bool)dal.ExecuteScalar("SELECT [NeedEmployee] FROM [Status] WHERE [Id] = @Id");
                dal.ClearParameters();
            }

            trAssignedMANR.Visible = trAssignedStabsnummer.Visible = trAssignedName.Visible = trTaxType.Visible = needEmployee;
        }

        protected void txtAssignedMANR_TextChanged(object sender, EventArgs e)
        {
            int manr;

            if (int.TryParse(txtAssignedMANR.Text, out manr))
            {
                DataAccessLayer dal = new DataAccessLayer();
                dal.AddParameter("@MANR", txtAssignedMANR.Text, DbType.String);
                dal.AddParameter("@Stabsnummer", null, DbType.String, ParameterDirection.Output);
                dal.AddParameter("@Name", null, DbType.String, ParameterDirection.Output);
                dal.ExecuteScalar("SELECT @Stabsnummer = [Stabsnummer], @Name = [Name] FROM [Employees] WHERE [MANR] = @MANR");

                txtAssignedStabsnummer.Text = dal.GetParameterValue("@Stabsnummer") == DBNull.Value ? "" : dal.GetParameterValue("@Stabsnummer").ToString();
                txtAssignedName.Text = dal.GetParameterValue("@Name") == DBNull.Value ? "" : dal.GetParameterValue("@Name").ToString();
                dal.ClearParameters();
            }

            txtAssignedStabsnummer.Focus();
        }

        protected void txtAssignedStabsnummer_TextChanged(object sender, EventArgs e)
        {
            if (txtAssignedMANR.Text == "" && txtAssignedStabsnummer.Text != "")
            {
                DataAccessLayer dal = new DataAccessLayer();
                dal.AddParameter("@MANR", null, DbType.String, ParameterDirection.Output);
                dal.AddParameter("@Stabsnummer", txtAssignedStabsnummer.Text, DbType.String);
                dal.AddParameter("@Name", null, DbType.String, ParameterDirection.Output);
                dal.ExecuteScalar("SELECT @MANR = [MANR], @Name = [Name] FROM [Employees] WHERE [Stabsnummer] = @Stabsnummer");

                txtAssignedMANR.Text = dal.GetParameterValue("@MANR") == DBNull.Value ? "" : dal.GetParameterValue("@MANR").ToString();
                txtAssignedName.Text = dal.GetParameterValue("@Name") == DBNull.Value ? "" : dal.GetParameterValue("@Name").ToString();
                dal.ClearParameters();
            }

            txtAssignedName.Focus();
        }

        protected void ddlTaxType_DataBound(object sender, EventArgs e)
        {
            ddlTaxType.SelectedIndex = 2;
        }
    }
}