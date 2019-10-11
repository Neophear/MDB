using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;
using MDB.AppCode;

namespace MDB.admin
{
    public partial class customtable : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void gvResult_Sorting(object sender, GridViewSortEventArgs e)
        {
            DataTable dtGridData = ViewState["dtResult"] as DataTable;
            DataView dvGridDataView = dtGridData.DefaultView;
            string strSortOrder = "";

            if (ViewState["SortOrder"] == null)
                ViewState["SortOrder"] = "asc";

            if (ViewState["SortOrder"].ToString() == "asc")
            {
                ViewState["SortOrder"] = "desc";
                strSortOrder = "desc";
            }
            else if (ViewState["SortOrder"].ToString() == "desc")
            {
                ViewState["SortOrder"] = "asc";
                strSortOrder = "asc";
            }
            dvGridDataView.Sort = e.SortExpression + " " + strSortOrder;
            dtGridData = dvGridDataView.ToTable();

            gvResult.DataSource = dtGridData;
            gvResult.DataBind();
        }

        protected void btnDownload_Click(object sender, EventArgs e)
        {
            ExportToCSV();
        }

        private void ExportToCSV()
        {
            DataTable dt = ViewState["dtResult"] as DataTable;

            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", $"attachment;filename=mdbexport{DateTime.Now:yyyyMMddHHmmss}.csv");
            Response.Charset = "";
            Response.ContentType = "application/text";
            Response.ContentEncoding = Encoding.GetEncoding("Windows-1252");

            StringBuilder sb = new StringBuilder();
            foreach (DataColumn col in dt.Columns)
                sb.Append(col.ColumnName + ';');

            sb.Append("\r\n");

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                for (int k = 0; k < dt.Columns.Count; k++)
                    sb.Append("\"" + dt.Rows[i][k].ToString().Replace(";", ",").Replace("\"", "'") + "\";");

                sb.Append("\r\n");
            }
            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        protected void gvResult_DataBound(object sender, EventArgs e)
        {
            btnDownload.Visible = gvResult.DataSource != null;
        }

        protected void dvPreset_DataBound(object sender, EventArgs e)
        {
            if (dvPreset.CurrentMode == DetailsViewMode.Insert)
                BindVisibleToUsers();
            else if (dvPreset.CurrentMode == DetailsViewMode.ReadOnly)
                BindVisibleToUsers(DataBinder.Eval(dvPreset.DataItem, "VisibleToUsers").ToString(), false);
            else if (dvPreset.CurrentMode == DetailsViewMode.Edit)
                BindVisibleToUsers(DataBinder.Eval(dvPreset.DataItem, "VisibleToUsers").ToString());
        }

        private void BindVisibleToUsers(string visibleToUsers = "", bool enabled = true)
        {
            CheckBoxList chkbxlstVisibleToUsers = ((CheckBoxList)dvPreset.FindControl("chkbxlstVisibleToUsers"));

            foreach (MDBUser u in MDBUser.GetAllUsers())
            {
                ListItem li = new ListItem
                {
                    Text = u.FullName,
                    Value = u.UserName,
                    Enabled = enabled,
                    Selected = (visibleToUsers == "" ? false : visibleToUsers.Contains(u.UserName))
                };
                chkbxlstVisibleToUsers.Items.Add(li);
            }
        }

        protected void sdsPreset_Changing(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Executor"].Value = User.Identity.Name;

            CheckBoxList chkbxlstVisibleToUsers = ((CheckBoxList)dvPreset.FindControl("chkbxlstVisibleToUsers"));
            string visibleToUsers = "";
            foreach (ListItem li in chkbxlstVisibleToUsers.Items)
                if (li.Selected)
                    visibleToUsers += $"{li.Value},";

            e.Command.Parameters["@VisibleToUsers"].Value = visibleToUsers.Trim(',');
        }

        protected void lstbxPresets_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lstbxPresets.SelectedIndex != -1)
                dvPreset.ChangeMode(DetailsViewMode.ReadOnly);
            else
                dvPreset.ChangeMode(DetailsViewMode.Insert);
        }

        protected void lnkbtnReadOnlyCancel_Click(object sender, EventArgs e)
        {
            dvPreset.ChangeMode(DetailsViewMode.Insert);
            lstbxPresets.SelectedIndex = -1;
        }

        protected void lnkbtnEditCancel_Click(object sender, EventArgs e)
        {
            dvPreset.ChangeMode(DetailsViewMode.ReadOnly);
        }

        protected void btnRunQuery_Click(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();
            try
            {
                string query = dvPreset.CurrentMode == DetailsViewMode.ReadOnly ? ((Label)dvPreset.FindControl("lblQuery")).Text : ((TextBox)dvPreset.FindControl("txtQuery")).Text;
                DataAccessLayer selectDal = new DataAccessLayer("SelectConnectionString");
                DataTable dt = dal.ExecuteDataTable(query);
                ViewState["dtResult"] = dt;
                ViewState["SortOrder"] = null;

                gvResult.DataSource = dt;
                btnDownload.Visible = true;
            }
            catch (Exception m)
            {
                lblMessage.Visible = true;
                lblMessage.Text = m.Message;
            }
            finally
            {
                gvResult.DataBind();
            }
        }
    }
}