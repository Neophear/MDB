using System.Data;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace Stiig
{
    public class DataAccessLayer
    {
        private SqlConnection Conn;

        private List<SqlParameter> Parameters;

        public void AddParameter(string name, object value, DbType type, ParameterDirection direction = ParameterDirection.Input)
        {
            SqlParameter p = new SqlParameter(name, type);
            p.Value = value;
            p.Direction = direction;
            p.Size = -1;
            Parameters.Add(p);
        }
        public object GetParameterValue(string name)
        {
            return Parameters.Find(x => x.ParameterName == name).Value;
        }
        public void ClearParameters()
        {
            Parameters.Clear();
        }
        public DataAccessLayer()
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            Conn = new SqlConnection(connectionstring);
            Parameters = new List<SqlParameter>();
        }
        public DataAccessLayer(string connectionStringName)
        {
            string connectionstring = ConfigurationManager.ConnectionStrings[connectionStringName].ConnectionString;
            Conn = new SqlConnection(connectionstring);
            Parameters = new List<SqlParameter>();
        }
        public DataTable ExecuteDataTable(string SQL)
        {
            DataTable dt;

            using (SqlCommand Comm = Conn.CreateCommand())
            {
                Comm.CommandText = SQL;

                if (Parameters.Count > 0)
                    Comm.Parameters.AddRange(Parameters.ToArray());

                SqlDataAdapter da = new SqlDataAdapter(Comm);
                dt = new DataTable();
                da.Fill(dt);
            }

            return dt;
        }
        public SqlDataReader ExecuteReader(string SQL)
        {
            SqlCommand Comm = Conn.CreateCommand();
            Comm.CommandText = SQL;
            Comm.CommandType = CommandType.Text;

            if (Parameters.Count > 0)
                Comm.Parameters.AddRange(Parameters.ToArray());

            Conn.Open();

            SqlDataReader Reader = Comm.ExecuteReader(CommandBehavior.CloseConnection);

            return Reader;
        }
        public int ExecuteNonQuery(string SQL)
        {
            using (SqlCommand Comm = Conn.CreateCommand())
            {
                Comm.CommandText = SQL;

                if (Parameters.Count > 0)
                    Comm.Parameters.AddRange(Parameters.ToArray());

                Conn.Open();
                int i = Comm.ExecuteNonQuery();
                Conn.Close();

                return i;
            }
        }
        public object ExecuteScalar(string SQL)
        {
            object result;
            using (SqlCommand Comm = Conn.CreateCommand())
            {
                Comm.CommandText = SQL;
                if (Parameters.Count > 0)
                    Comm.Parameters.AddRange(Parameters.ToArray());

                Conn.Open();
                result = Comm.ExecuteScalar();
                Conn.Close();
            }
            return result;
        }
        public object ExecuteStoredProcedure(string SQL)
        {
            object result;
            using (SqlCommand Comm = Conn.CreateCommand())
            {
                Comm.CommandType = CommandType.StoredProcedure;
                Comm.CommandText = SQL;
                if (Parameters.Count > 0)
                    Comm.Parameters.AddRange(Parameters.ToArray());

                Conn.Open();
                result = Comm.ExecuteScalar();
                Conn.Close();
            }
            return result;
        }
    }
}