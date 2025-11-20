function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

@delay function hfun_blogposts()
    today = Dates.today()
    curyear = year(today)
    curmonth = month(today)
    curday = day(today)

    list = readdir("posts")

    filter!(endswith(".md"), list)
    function sorter(p)
        ps = splitext(p)[1]
        url = "posts/$ps/"
        surl = strip(url, '/')
        pubdate = pagevar(surl, "rss_pubdate")
        #if isnothing(pubdate)
        #    return Date(Dates.unix2datetime(stat(surl * ".md").ctime))
        #end
        #return Date(pubdate, dateformat"yyyy-mm-dd")
    end
    sort!(list, by=sorter, rev=true)

    io = IOBuffer()
    #write(io, """<ul class="blog-posts">""")

    write(io, """<div class="franklin-content">""")
    for (i, post) in Iterators.reverse(enumerate(list))
        if post == "content/index.md"
            continue
        end
        ps = splitext(post)[1]
        write(io, "<li>")
        url = "/posts/$ps/"
        url_aux = "/posts/$ps/"
        surl = strip(url, '/')
        title = pagevar(surl, "title")
        pubdate = pagevar(surl, "date")
        description = pagevar(surl, "rss_description")
        if isnothing(pubdate)
            date = "$curyear-$curmonth-$curday"
        else
            #date = Date(pubdate, dateformat"yyyy-mm-dd")
        end
        write(io, """$pubdate<br>""")
        write(io, """<a href="$url_aux">$title</a></b><p>""")
    end
    write(io, "</div>")
    return String(take!(io))
end