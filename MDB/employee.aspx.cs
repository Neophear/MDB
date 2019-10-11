using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Novacode;
using Stiig;

namespace MDB
{
    public partial class employee : System.Web.UI.Page
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
                    dvEmployee.ChangeMode(DetailsViewMode.Insert);
                    gvCurrentOrders.Enabled = false;
                }
                else
                {
                    ShowLog.ObjectId = objectId;
                    ShowLog.ObjectTypeId = 2;
                    Comments.ObjectId = objectId;
                    Comments.ObjectTypeId = 2;
                }
            }

            ShowLog.Visible = User.IsInRole("Admin") && objectId != -1;
            Page.Title = objectId == -1 ? "Ny medarbejder" : $"Medarbejder {objectId}";
        }

        protected void sdsEmployee_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;
        }

        void SetMessage(string m, bool e = true)
        {
            lblMessage.Text = m;
            lblMessage.CssClass = e ? "error" : "";
            lblMessage.Visible = true;
        }

        protected void dvEmployee_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            e.Cancel = EmployeeExists(e.Values["MANR"].ToString());
        }

        protected void dvEmployee_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            e.Cancel = EmployeeExists(e.NewValues["MANR"].ToString(), (int)e.Keys["Id"]);
        }

        private bool EmployeeExists(string manr, int? id = null)
        {
            bool result = AppCode.Functions.CheckIfObjectExists(manr, AppCode.Functions.ObjectType.Employee, id);
            if (result)
                SetMessage("MANR findes i forvejen");
            return result;
        }

        protected void sdsEmployee_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            Response.Redirect($"~/employee/{e.Command.Parameters["@LastId"].Value}");
        }

        protected void sdsEmployee_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            gvCurrentOrders.DataBind();
        }

        protected void sdsEmployee_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.AffectedRows == -1)
                SetMessage("MA blev ikke slettet! Fjern alle genstande fra brugeren først.");
            else
                Response.Redirect("~/employees");
        }

        protected void dvEmployee_DataBound(object sender, EventArgs e)
        {
            dvEmployee.Rows[dvEmployee.Rows.Count - 1].Visible = AppCode.Globals.CanUserWrite();
        }

        protected void gvCurrentOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string sp = "";

            if (e.CommandName == "Storage")
                sp = "SetOrderToStorage";
            else if (e.CommandName == "Approve")
                sp = "OrderApprove";

            if (sp != "")
            {
                DataAccessLayer dal = new DataAccessLayer();

                dal.AddParameter("@OrderId", e.CommandArgument, System.Data.DbType.Int32);
                dal.AddParameter("@Executor", User.Identity.Name, System.Data.DbType.String);
                dal.ExecuteStoredProcedure(sp);
                dal.ClearParameters();

                gvCurrentOrders.DataBind();
            }
        }

        protected void lnkbtnSetSignedSolemnDeclaration_Click(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();

            dal.AddParameter("@EmployeeId", Page.RouteData.Values["id"], System.Data.DbType.Int32);
            dal.AddParameter("@Executor", User.Identity.Name, System.Data.DbType.String);
            dal.ExecuteStoredProcedure("SetEmployeeSignedSolemnDeclaration");
            dal.ClearParameters();

            dvEmployee.DataBind();
        }
    }
}