import { CChart } from '@coreui/react-chartjs'
import { Modal, Col, Container } from "react-bootstrap"
import {useEffect} from 'react'
import { useDispatch, useSelector } from "react-redux";
import { get_report } from "./actions"

let Report = (props) => {
  const dispatch = useDispatch()
  const {show, handleClose} = props
  const proponents = useSelector(state => state.proponents)
  const { report, list } = proponents

  useEffect(() => {
    dispatch(get_report())
  }, [list])

  return (
    <Col>
      <Modal size="md" centered show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            <blockquote className="blockquote mb-0">
              <p className="mb-0">Proponents</p>
              <footer className="mt-0 blockquote-footer">Report</footer>
            </blockquote>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="show-grid">
          <Container>
            <CChart
              type="doughnut"
              data={{
                labels: Object.keys(report).map(elem => `${(elem * 100).toFixed(3)}%`),
                datasets: [
                  {
                    backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
                    data: Object.values(report),
                  },
                ],
              }}
            />
          </Container>
        </Modal.Body>
        <Modal.Footer>
        </Modal.Footer>
      </Modal>
    </Col>
  )
}

export default Report;
