<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="PostDetail.aspx.cs" Inherits="tvSeries.Admin.PostDetail" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="/Styles/Admin/PostDetail.css" />
    <link rel="stylesheet" href="/Styles/Admin/SeriesMain.css" />
    <link rel="stylesheet" href="/Styles/Admin/EpisodeItemList.css" />
    <link rel="stylesheet" href="/Styles/Admin/EpisodeItem.css" />
    <script runat="server">
        int id = 0;
        String trailerImageStr = "";
        String[] trailerImageArr;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                id = Int32.Parse(Request.QueryString["id"].ToString());
                GetPostDetail();
            }

        }

        protected void GetPostDetail()
        {
            SqlConnection conn =
               new SqlConnection("Data Source=.\\SQLEXPRESS; Initial Catalog=MyDB; Integrated Security=False; uid=killi8n; pwd=admin1234");
            String SQL = "SELECT * FROM tvseries.dbo.Series WHERE id = @Id";
            SqlCommand command = new SqlCommand(SQL, conn);
            command.Parameters.AddWithValue("@Id", id);

            try
            {
                conn.Open();

                SqlDataReader rd = command.ExecuteReader();

                while (rd.Read())
                {
                    ThumbnailImage.ImageUrl = "/Uploads/" + rd["trailerImage"].ToString().Split(',')[0];
                    TitleLabel.Text = rd["title"].ToString();
                    GenreLabel.Text = rd["genre"].ToString();
                    YearLabel.Text = rd["year"].ToString();
                    trailerImageStr = rd["trailerImage"].ToString();
                    StoryLabel.Text = rd["story"].ToString();
                }

                trailerImageArr = trailerImageStr.Split(',');
            }
            catch (Exception exception)
            {
                Response.Write(exception.Message.ToString());
            }
            finally
            {
                conn.Close();
            }
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="SeriesHeader">
        <div class="Wrapper">
            <header>
                <div class="Logo">TV-SERIES</div>
                
            </header>
            <div class="header-contents">
                <div class="thumbnail-area">
                    <div class="floating-thumbnail">
                        <asp:Image runat="server" ID="ThumbnailImage" />
                    </div>
                </div>
                <div class="information">
                    <div>
                        <h1>
                            <asp:Label ID="TitleLabel" runat="server" />
                        </h1>
                        <div class="sub-info">
                            <span>
                                <asp:Label runat="server" ID="GenreLabel"></asp:Label></span>
                            <span>
                                <asp:Label runat="server" ID="YearLabel"></asp:Label></span>
                        </div>
                    </div>
                    <div class="ButtonWrapper">
                        
                        <a href="/Admin/Editor.aspx?id=<%=id %>" class="Button">수정하기</a>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="SeriesMain">
        <div class="Wrapper">
            <div class="content">
                <section>
                    <h2>관련 이미지</h2>
                    
                    <div class="EpisodeItemList">
                        <% for (int i = 0; i < trailerImageArr.Length - 1; i++)
                            { %>
                        <div class="EpisodeItem">
                            <div class="episode-thumbnail">
                                <img src="/Uploads/<%=trailerImageArr[i] %>" alt="episode-thumbnail" />
                            </div>
                        </div>
                        <%} %>
                    </div>
                </section>
                <section>
                    <h2>줄거리</h2>
                    <p><asp:Label ID="StoryLabel" runat="server"></asp:Label></p>
                </section>
            </div>
        </div>
    </div>
</asp:Content>
