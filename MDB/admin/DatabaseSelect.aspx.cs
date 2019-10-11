using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB.admin
{
    public partial class DatabaseSelect : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMessage.Visible = false;
            btnDownload.Visible = false;
        }

        protected void btnRun_Click(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer("SelectConnectionString");
            try
            {
                gvResult.DataSource = null;
                DataTable dt = dal.ExecuteDataTable(txtQuery.Text);
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
        //public override void VerifyRenderingInServerForm(Control control)
        //{
            
        //}
    }
}