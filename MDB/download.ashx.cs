using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Novacode;
using Stiig;

namespace MDB
{
    /// <summary>
    /// Summary description for download
    /// </summary>
    public class download : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string filename = context.Request.QueryString["f"];

            if (filename.StartsWith("trolove"))
            {
                string manr = filename.Substring(7, 6);
                DataAccessLayer dal = new DataAccessLayer();
                dal.AddParameter("@MANR", manr, System.Data.DbType.String);
                dal.AddParameter("@Stabsnummer", null, System.Data.DbType.String, System.Data.ParameterDirection.Output);
                dal.AddParameter("@Name", null, System.Data.DbType.String, System.Data.ParameterDirection.Output);
                dal.ExecuteStoredProcedure("GetEmployeeInfo");

                if (dal.GetParameterValue("@Stabsnummer") == DBNull.Value || dal.GetParameterValue("@Name") == DBNull.Value)
                    throw new System.IO.FileNotFoundException();
                else
                {
                    string stabsnummer = dal.GetParameterValue("@Stabsnummer").ToString();
                    string name = dal.GetParameterValue("@Name").ToString();
                    System.IO.MemoryStream filestream = new System.IO.MemoryStream();

                    using (DocX document = DocX.Load(context.Server.MapPath("~/Files/solemndeclaration.docx")))
                    {
                        document.InsertAtBookmark(manr, "MANR");
                        document.InsertAtBookmark($"{stabsnummer} {name}", "OutlookName");
                        document.InsertAtBookmark(DateTime.Today.ToString("dd-MM-yyyy"), "Date");
                        document.SaveAs(filestream);
                    }

                    context.Response.ClearContent();
                    context.Response.Clear();
                    context.Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                    context.Response.AddHeader("Content-Disposition", $"attachment; filename=trolove{manr}.docx");

                    filestream.WriteTo(context.Response.OutputStream);

                    context.Response.Flush();
                    context.Response.Close();
                }
            }
            else
                throw new Exception();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}