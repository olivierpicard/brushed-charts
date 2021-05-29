from datetime import datetime, timezone

ACCEPTABLE_DELAY = 15 * 60
MAIL_INTERVAL = 24*60*60  # seconds


def is_correct(document: dict):
    if not is_update_time_valid(document):
        return False
    if not document['validity']:
        return False
    
    return True


def is_update_time_valid(document):
    update_datetime = document['updated_at']
    refresh_rate = document['refresh_rate']
    utcnow = datetime.now(timezone.utc)
    update_diff = (utcnow - update_datetime).total_seconds()
    
    if update_diff + ACCEPTABLE_DELAY > refresh_rate:
        document['warning'] = "There is too long since this document was updated"
        return False
    
    return True


def is_ready_for_email(health_ref: str, docs: list[dict]):
    if not _docs_contain_ref(health_ref, docs):
        return True
    dt = docs[0]['last_email']
    diff = datetime.now(timezone.utc) - dt
    if diff.total_seconds() >= MAIL_INTERVAL:
        return True
    
    return False


def _docs_contain_ref(health_ref: str, docs: list[dict]):
    if docs is None:
        return False
    filtered = list(filter(lambda doc: doc['ref'] == health_ref, docs))
    if len(filtered) == 0:
        return False
    
    return True
