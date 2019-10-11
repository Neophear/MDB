using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stiig;

namespace MDB
{
    public partial class redirect : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataAccessLayer dal = new DataAccessLayer();
            string type = RouteData.Values["type"].ToString();
            short objectType;
            int objectId;

            if (type == "order" || type == "comment")
            {
                dal.AddParameter("@InputTypeId", (type == "order" ? 5 : 10), System.Data.DbType.Int16);
                dal.AddParameter("@InputObjectId", RouteData.Values["Id"], System.Data.DbType.Int32);
                dal.AddParameter("@ObjectType", null, System.Data.DbType.Int16, System.Data.ParameterDirection.Output);
                dal.AddParameter("@ObjectId", null, System.Data.DbType.Int32, System.Data.ParameterDirection.Output);
                dal.ExecuteStoredProcedure("GetRedirectInfo");

                if (dal.GetParameterValue("@ObjectType") == DBNull.Value)
                    Server.Transfer("~/error.aspx?e=notexist");
                else
                {
                    objectType = Convert.ToInt16(dal.GetParameterValue("@ObjectType"));
                    objectId = Convert.ToInt32(dal.GetParameterValue("@ObjectId"));
                    dal.ClearParameters();

                    if (objectType == 2)
                        Response.Redirect($"~/employee/{objectId}", true);
                    else if (objectType == 3)
                        Response.Redirect($"~/device/{objectId}", true);
                    else if (objectType == 4)
                        Response.Redirect($"~/simcard/{objectId}", true);
                }
            }
        }
    }
}