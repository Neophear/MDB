using System;
using System.Web;
using System.Web.UI;
using System.Web.Routing;

namespace MDB
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            string JQueryVer = "3.2.1";
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            {
                Path = "~/Scripts/jquery-" + JQueryVer + ".min.js",
                DebugPath = "~/Scripts/jquery-" + JQueryVer + ".js",
                CdnPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".min.js",
                CdnDebugPath = "http://ajax.aspnetcdn.com/ajax/jQuery/jquery-" + JQueryVer + ".js",
                CdnSupportsSecureConnection = true,
                LoadSuccessExpression = "window.jQuery"
            });

            RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            //string url = HttpContext.Current.Request.Url.AbsolutePath;

            //if (!url.ToLower().EndsWith("error.aspx") && !url.ToLower().EndsWith("default.aspx") && url.ToLower().EndsWith(".aspx"))
            //    Response.Redirect(url.Remove(url.Length - 5));

            Uri url = HttpContext.Current.Request.Url;

            if (url.Port == 80)
                Response.Redirect($"https://{url.Host}:8080{url.PathAndQuery}");
        }

        void RegisterRoutes(RouteCollection routes)
        {
            string[] pages = {
                "default",
                "public/login",
                "devices",
                "simcards",
                "employees",
                "customtable",
                "settings",
                "missingapprovals",
                "admin/settings",
                "admin/default",
                "admin/customtable",
                "admin/users",
                "admin/bulkupdate",
                "admin/userlog",
                "admin/log",
                "admin/changelog",
                "admin/muster"
            };

            foreach (string page in pages)
                routes.MapPageRoute(
                    page,
                    page,
                    $"~/{page}.aspx",
                    true);

            foreach (string page in new string[] { "employee", "device", "simcard" })
            {
                routes.MapPageRoute(page,
                    $"{page}/{{id}}",
                    $"~/{page}.aspx", true,
                    new RouteValueDictionary {
                        { "id", "" } },
                    new RouteValueDictionary {
                        { "id", @"\d+" } });

                routes.MapPageRoute($"{page}/new",
                    $"{page}/new",
                    $"~/{page}.aspx", true);
            }

            routes.MapPageRoute("device/multiinsert",
                "device/multiinsert",
                "~/multideviceinsert.aspx", true);

            routes.MapPageRoute("simcard/multiinsert",
                "simcard/multiinsert",
                "~/multisimcardinsert.aspx", true);

            routes.MapPageRoute("employee/multiinsert",
                "employee/multiinsert",
                "~/multiemployeeinsert.aspx", true);

            routes.MapPageRoute("admin/sql",
                "admin/sql",
                "~/admin/DatabaseSelect.aspx", true);

            routes.MapPageRoute("admin/user",
                "admin/user/{username}",
                "~/admin/user.aspx", true,
                new RouteValueDictionary {
                    { "username", "" } },
                new RouteValueDictionary {
                    { "username", @".*" } });

            routes.MapPageRoute("search",
                "search/{string}",
                "~/search.aspx", true,
                new RouteValueDictionary {
                    { "string", "" } },
                new RouteValueDictionary {
                    { "string", @".*" } });

            routes.MapPageRoute("admin/news",
                "admin/news/{id}",
                "~/admin/news.aspx", true,
                new RouteValueDictionary {
                    { "id", "" } },
                new RouteValueDictionary {
                    { "id", @"\d*" } });

            routes.MapPageRoute("order",
                "order/{id}",
                "~/redirect.aspx", true,
                new RouteValueDictionary {
                    { "type", "order" }, { "id", "" } },
                new RouteValueDictionary {
                    { "id", @"\d*" } });

            routes.MapPageRoute("comment",
                "comment/{id}",
                "~/redirect.aspx", true,
                new RouteValueDictionary {
                    { "type", "comment" }, { "id", "" } },
                new RouteValueDictionary {
                    { "id", @"\d*" } });
        }
    }
}