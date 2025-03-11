import useHttp from "@/hooks/useHttp"
import { useEffect } from "react";

const useContactsGet = () => {
    const {response, loading, error, sendRequest} = useHttp();

    useEffect(() => {
        sendRequest({
            url: "/customers",
            method: "GET"})
    },[])

    return {
        response,
        loading,
        error,
    }
}

export default useContactsGet;