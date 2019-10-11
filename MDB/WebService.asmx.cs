using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;
using Stiig;

namespace MDB
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {
        [System.Web.Script.Services.ScriptMethod()]
        [System.Web.Services.WebMethod]
        public List<string> GetModels(string prefixText, int count)
        {
            return GetList($"SELECT TOP {count} [Model] FROM [ModelsView] WHERE [Model] COLLATE Latin1_General_CI_AS LIKE @search + '%' ORDER BY [Model]", prefixText);
        }

        [System.Web.Script.Services.ScriptMethod()]
        [WebMethod]
        public List<string> GetProviders(string prefixText, int count)
        {
            return GetList($"SELECT TOP {count} [Provider] FROM [ProvidersView] WHERE [Provider] COLLATE Latin1_General_CI_AS LIKE @search + '%' ORDER BY [Provider]", prefixText);
        }

        private List<string> GetList(string sql, string prefixText)
        {
            DataAccessLayer dal = new DataAccessLayer();
            List<string> list = new List<string>();
            dal.AddParameter("@search", prefixText, DbType.String);
            DataTable dt = dal.ExecuteDataTable(sql);
            dal.ClearParameters();

            foreach (DataRow row in dt.Rows)
                list.Add(row[0].ToString());

            return list;
        }

        [WebMethod]
        public bool Exists(string uniqueIdentifier, AppCode.Functions.ObjectType type)
        {
            DataAccessLayer dal = new DataAccessLayer();
            dal.AddParameter("@UniqueIdentifier", uniqueIdentifier, DbType.String);
            dal.AddParameter("@ObjectType", (int)type, DbType.Int32);
            dal.AddParameter("@Exists", null, DbType.String, ParameterDirection.Output);
            dal.ExecuteStoredProcedure("ObjectExists");
            bool result = dal.GetParameterValue("@Exists").ToString() == "1";
            dal.ClearParameters();
            return result;
        }
    }
}