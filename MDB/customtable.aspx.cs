using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class customtable : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            btnDownload.Visible = false;
        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();
            try
            {
                dal.AddParameter("@Id", lstbxPresets.SelectedValue, DbType.Int32);
                dal.AddParameter("@Role", Roles.GetRolesForUser()[0], DbType.String);
                dal.AddParameter("@Username", User.Identity.Name, DbType.String);
                dal.AddParameter("@Query", null, DbType.String, ParameterDirection.Output);
                dal.ExecuteStoredProcedure("GetSQLPresetQuery");
                object query = dal.GetParameterValue("@Query");
                dal.ClearParameters();

                if (query != null)
                {
                    DataAccessLayer selectDal = new DataAccessLayer("SelectConnectionString");
                    DataTable dt = dal.ExecuteDataTable(query.ToString());
                    ViewState["dtResult"] = dt;
                    ViewState["SortOrder"] = null;

                    gvResult.DataSource = dt;
                    btnDownload.Visible = true;
                }
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

        //private void ExportToExcel()
        //{
        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.AddHeader("content-disposition", $"attachment;filename=mdbexport{DateTime.Now:yyyyMMddHHmmss}.xls");
        //    Response.Charset = "";
        //    Response.ContentType = "application/vnd.ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter hw = new HtmlTextWriter(sw);

        //    gvResult.RenderControl(hw);
        //    //style to format numbers to string
        //    string style = @"<style> .textmode { mso-number-format:\@; } </style>";
        //    Response.Write(style);
        //    Response.Output.Write(sw.ToString());
        //    Response.Flush();
        //    Response.End();
        //}

        protected void gvResult_DataBound(object sender, EventArgs e)
        {
            btnDownload.Visible = gvResult.DataSource != null;
        }

        protected void sdsPresets_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            e.Command.Parameters["@Role"].Value = Roles.GetRolesForUser()[0];
            e.Command.Parameters["@Username"].Value = User.Identity.Name;
        }

        protected void lstbxPresets_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lstbxPresets.SelectedIndex != -1)
            {
                DataView dv = sdsPreset.Select(DataSourceSelectArguments.Empty) as DataView;

                pnlPreset.Visible = true;
                lblName.Text = dv[0]["Name"].ToString();
                lblDescription.Text = Utilities.ToggleHtmlBR(dv[0]["Description"].ToString(), true);
            }
            else
            {
                pnlPreset.Visible = false;
            }
        }
        //public override void VerifyRenderingInServerForm(Control control)
        //{

        //}
    }
}