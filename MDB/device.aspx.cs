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
    public partial class device : Page
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
                    dvDevice.ChangeMode(DetailsViewMode.Insert);
                    gvOrders.Enabled = false;
                }
                else
                {
                    ShowLog.ObjectId = objectId;
                    ShowLog.ObjectTypeId = 3;
                    Comments.ObjectId = objectId;
                    Comments.ObjectTypeId = 3;
                }
            }

            ShowLog.Visible = User.IsInRole("Admin") && objectId != -1;
            Page.Title = objectId == -1 ? "Ny enhed" : $"Enhed {objectId}";
        }

        protected void dvDevice_DataBound(object sender, EventArgs e)
        {
            if (dvDevice.CurrentMode == DetailsViewMode.Edit)
            {
                ((DropDownList)dvDevice.FindControl("ddlUnit")).SelectedValue = DataBinder.Eval(dvDevice.DataItem, "UnitRefId").ToString();
                ((DropDownList)dvDevice.FindControl("ddlType")).SelectedValue = DataBinder.Eval(dvDevice.DataItem, "TypeRefId").ToString();

                foreach (DetailsViewRow row in dvDevice.Rows)
                    if (row.Cells[0].Text == "Status")
                        row.Visible = false;
            }

            if (dvDevice.CurrentMode != DetailsViewMode.ReadOnly)
                ((TextBox)dvDevice.FindControl("txtBuyDate")).Attributes.Add("readonly", "readonly");

            dvDevice.Rows[dvDevice.Rows.Count - 1].Visible = AppCode.Globals.CanUserWrite();
            pnlInsertOrder.Visible = AppCode.Globals.CanUserWrite() && dvDevice.CurrentMode == DetailsViewMode.ReadOnly;
        }

        protected void sdsDevice_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;

            if (e.Command.CommandText == "DeviceInsert" || e.Command.CommandText == "DeviceUpdate")
            {
                e.Command.Parameters["@UnitRefId"].Value = ((DropDownList)dvDevice.FindControl("ddlUnit")).SelectedValue;
                e.Command.Parameters["@TypeRefId"].Value = ((DropDownList)dvDevice.FindControl("ddlType")).SelectedValue;
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
            dal.AddParameter("@ObjectTypeRefId", 3, DbType.Int16);
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

        protected void dvDevice_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            e.Cancel = DeviceExists(e.Values["IMEI"].ToString());
        }

        protected void dvDevice_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            e.Cancel = DeviceExists(e.NewValues["IMEI"].ToString(), (int)e.Keys["Id"]);
        }

        private bool DeviceExists(string imei, int? id = null)
        {
            bool result = AppCode.Functions.CheckIfObjectExists(imei, AppCode.Functions.ObjectType.Device, id);
            if (result)
                SetMessage("IMEI findes i forvejen");
            return result;
        }

        protected void sdsDevice_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect("~/devices");
        }

        protected void sdsDevice_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect($"~/device/{e.Command.Parameters["@LastId"].Value}");
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

            if (needEmployee)
                txtAssignedMANR.Focus();
            else
                txtOrderNotes.Focus();
        }

        protected void txtAssignedMANR_TextChanged(object sender, EventArgs e)
        {
            if (int.TryParse(txtAssignedMANR.Text, out int manr))
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

        protected void dvDevice_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            Server.TransferRequest(Request.Url.AbsolutePath, false);
        }
    }
}