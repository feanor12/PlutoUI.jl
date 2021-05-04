export CSSWidgetWrapper, JSWidgetWrapper

"""
    JSWidgetWrapper(widget, js)

Inject a script tag where `widget` is set to the first html element of the passed widget.

# Examples
```
Change the text color to red when the textfield is focused, otherwise set is to green.
begin
    script = \"\"\"
    widget.onblur = function(){widget.style.color='green'};
    widget.onfocus = function(){widget.style.color='red'};
    \"\"\"
    @bind text JSWidgetWrapper(TextField(),script)
end
```
"""
struct JSWidgetWrapper
    widget
    js
end

function show(io::IO, m::MIME"text/html", w::JSWidgetWrapper)
    script = """
        <script>
        var widget = currentScript.parentElement.firstElementChild
        $(w.js)    
        </script>
    """
    show(io,m,w.widget)
    print(io,script)
end

Base.get(w::JSWidgetWrapper) = get(w.widget)


"""
    CSSWidgetWrapper(widget, style::Dict{String,String})

Modify the style properties of the first HTML node for the given widget. 

# Examples
Generate a text field with a red background and white text.
```
@bind text CSSWidgetWrapper(TextField(),Dict("backgroundColor"=>"red","color"=>"white"))
```
Generate a text field with 1px wide solid red border.
```
@bind text CSSWidgetWrapper(TextField(),Dict("border"=>"1px solid red"))
```
"""
function CSSWidgetWrapper(widget, style::Dict{String,String}) 
    stylejs = join(["widget.style.$k = '$v';" for (k,v) in style],"\n")
    JSWidgetWrapper(widget, stylejs)
end