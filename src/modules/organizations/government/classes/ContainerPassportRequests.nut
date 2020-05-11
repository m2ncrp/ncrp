class ContainerPassportRequests extends Container
{
    static classname = "ContainerPassportRequests";

    function push(element) {
        this.add(this.len(), element);
    }
}
