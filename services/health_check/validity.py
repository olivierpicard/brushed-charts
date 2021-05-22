from datetime import datetime, timezone

THREE_MINUTES = 3 * 60


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
    
    if update_diff + THREE_MINUTES > refresh_rate:
        document['warning'] = "There is too long since this document was updated"
        return False
    
    return True
