import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from "react-redux";
import { getProponents } from './actions'
import { Button } from "react-bootstrap";

const Paginator = () => {
  const dispatch = useDispatch()
  const proponents = useSelector(state => state.proponents)
  const {list, complete} = proponents
  const [page, setPage] = useState(0)
  useEffect(() => {setPage(1)}, [])
  useEffect(() => {dispatch(getProponents(page))}, [page, dispatch])

  if(list.length === 0 || complete) return;

  return <Button onClick={() => setPage((page) => page + 1)}>More</Button>
}

export default Paginator
